#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require "etc"

MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1
NORMAL_BYTESIZE = 1
MULTI_BYTESIZE = 2
STICKEY_PERMISSION = "1"
SUID_PERMISSION = "2"
SGID_PERMISSION = "4"

FILE_TYPE = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}

PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}

SPECIAL_PERMISSION = {
  '0' => '-',
  '1' => 't',
  '2' => 's',
  '4' => 's',
}

def main
  option_params = OptionParser.new

  options = {}
  option_params.on('-a') { |param| options[:a] = param }
  option_params.on('-r') { |param| options[:r] = param }
  option_params.on('-l') { |param| options[:l] = param }

  option_params.parse!(ARGV)

  args = ARGV
  arg_directories = []
  arg_files = []
  arg_directories << Dir.open('.') if args.empty?

  args.each do |arg|
    next arg_directories << Dir.open(arg) if File.directory?(arg)
    next arg_files << arg if File.file?(arg)

    puts "ls: #{arg}: No such file or directory"
  end

  sorted_arg_files = sort_files(arg_files, options[:r])

  display_files(sorted_arg_files, options)
  puts if !arg_directories.empty? && !sorted_arg_files.empty?
  display_directories(arg_directories, args.size, options)
end

def display_files(files, options)
  return if files.empty?
  if options[:l]
    longformat_files = files.map { |file| generate_longformat_files(file, File.dirname(file)) }
    longest_bytesizes = fetch_longest_bytesizes(longformat_files)
    longformat_files.each do |longformat_file|
      puts display_longformat_file(longformat_file, longest_bytesizes)
    end
  else
    generated_files = generate_display_files(files)
    transpose_display_files(generated_files)
  end
end

def display_directories(directories, arg_counts, options)
  return if directories.empty?

  directories.each.with_index(1) do |directory, i|
    puts "#{directory.path}:" if arg_counts > 1
    # ls -lをしていない時
    directory_files = directory.entries.filter { |file| options[:a] ? file : !/^\./.match?(file) }
    sorted_directory_files = sort_files(directory_files, options[:r])
    next if sorted_directory_files.empty?

    generated_files = generate_display_files(sorted_directory_files)
    transpose_display_files(generated_files)
    #
    puts if i < directories.size
  end
end

def generate_display_files(files)
  longest_filename_length = files.map(&:bytesize).max
  file_counts_in_column = calculate_file_counts_in_column(longest_filename_length, files.size)
  slice_display_files(files, file_counts_in_column, longest_filename_length)
end

def calculate_file_counts_in_column(filename_length, file_counts)
  terminal_width = `tput cols`.to_i # `tput cols` = 実行するターミナルの幅を取得
  max_file_counts_in_row = terminal_width / (filename_length + BUFFER_WIDTH)
  min_file_counts_in_row = [max_file_counts_in_row, MIN_COLUMN].max
  file_counts_in_row = [min_file_counts_in_row, MAX_COLUMN].min
  (file_counts.to_f / file_counts_in_row).ceil
end

def slice_display_files(sorted_files, file_counts_in_column, longest_filename_length)
  sorted_files.each_slice(file_counts_in_column).map do |files|
    sliced_files = files.map { |file_name| file_name.ljust(calculate_align_left_width(file_name, longest_filename_length)) }
    sliced_file_counts = sliced_files.size
    (file_counts_in_column - sliced_file_counts).times { sliced_files << '' } if sliced_file_counts < file_counts_in_column
    sliced_files
  end
end

def calculate_align_left_width(file_name, longest_filename_length)
  adjusted_byte_number = file_name.each_char
                                  .map { |char| char.bytesize == NORMAL_BYTESIZE ? NORMAL_BYTESIZE : MULTI_BYTESIZE }
                                  .sum
  padding_size = [0, longest_filename_length - adjusted_byte_number].max
  padding_size + file_name.size
end

def transpose_display_files(display_files)
  display_files.transpose.each { |files| puts files.join(' ').strip }
end

def sort_files(files, option_r)
  option_r ? files.sort.reverse : files.sort
end

def generate_longformat_files(file, directory)
  file_stat = File::Stat.new(File.absolute_path(file, directory))
  file_stat_mode = file_stat.mode.to_s(8).rjust(6, "0")
  file_type = file_stat_mode.slice(0,2)
  special_permission = file_stat_mode.slice(2)
  owner_permission_string = conversion_special_permission(special_permission, file_stat_mode.slice(3), STICKEY_PERMISSION)
  group_permission_string = conversion_special_permission(special_permission, file_stat_mode.slice(4), SUID_PERMISSION)
  other_permission_string = conversion_special_permission(special_permission, file_stat_mode.slice(5), SGID_PERMISSION)
  {
    filemode: "#{FILE_TYPE[file_type]}#{owner_permission_string}#{group_permission_string}#{other_permission_string}",
    hardlink_nums:file_stat.nlink.to_s,
    owner_name: Etc.getpwuid(file_stat.uid).name,
    group_name: Etc.getgrgid(file_stat.gid).name,
    bytesize: file_stat.size.to_s,
    latest_modify_datetime: file_stat.mtime.strftime(" %-m %-d %H:%M"),
    filename: file,
    blocks: file_stat.blocks
  }
end

def fetch_longest_bytesizes(hash)
  {
    hardlink_num: hash.map { |h| h[:hardlink_nums].to_s.bytesize}.max,
    owner_name: hash.map { |h| h[:owner_name].bytesize}.max,
    group_name: hash.map { |h| h[:group_name].bytesize}.max,
    bytesize: hash.map { |h| h[:bytesize].to_s.bytesize}.max,
    filename: hash.map { |h| h[:filename].bytesize}.max
  }
end

def display_longformat_file(hash, longest_bytesizes)
  "#{hash[:filemode]} "\
  "#{hash[:hardlink_nums].rjust(longest_bytesizes[:hardlink_num] + 1)}"\
  "#{hash[:owner_name].rjust(longest_bytesizes[:owner_name] + 1)} "\
  "#{hash[:group_name].rjust(longest_bytesizes[:group_name] + 1)} "\
  "#{hash[:bytesize].rjust(longest_bytesizes[:bytesize] + 1)} "\
  "#{hash[:latest_modify_datetime]} #{hash[:filename]}"
end

def conversion_special_permission(special_permission, permission, target_permission)
  return PERMISSION[permission] if special_permission != target_permission
  permission.to_i.odd? ? PERMISSION[permission].sub(/x$/, SPECIAL_PERMISSION[special_permission]) : PERMISSION[permission].sub(/-$/, SPECIAL_PERMISSION[special_permission].upcase)
end

main
