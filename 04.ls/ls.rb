#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1
NORMAL_BYTESIZE = 1
MULTI_BYTESIZE = 2
STICKEY_PERMISSION = '1'
SUID_PERMISSION = '2'
SGID_PERMISSION = '4'

FILE_TYPE = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

SPECIAL_PERMISSION = {
  '0' => '-',
  '1' => 't',
  '2' => 's',
  '4' => 's'
}.freeze

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
    display_longformat_files(files)
  else
    generated_files = generate_display_files(files)
    transpose_display_files(generated_files)
  end
end

def display_directories(directories, arg_counts, options)
  return if directories.empty?

  directories.each.with_index(1) do |directory, i|
    puts "#{directory.path}:" if arg_counts > 1
    directory_files = generate_directory_files(directory, options[:a])
    sorted_directory_files = sort_files(directory_files, options[:r])
    next if sorted_directory_files.empty?

    if options[:l]
      display_longformat_directory_files(sorted_directory_files, directory.path)
    else
      generated_files = generate_display_files(sorted_directory_files)
      transpose_display_files(generated_files)
    end
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

def generate_directory_files(directory, option_a)
  directory.entries.filter { |file| option_a ? file : !/^\./.match?(file) }
end

def sort_files(files, option_r)
  option_r ? files.sort.reverse : files.sort
end

def display_longformat_files(files)
  longformat_files = files.map { |file| generate_longformat_file(file, File.path(file)) }
  longest_bytesizes = generate_longest_bytesizes(longformat_files)
  longformat_files.each { |longformat_file| puts generate_longformat_file_line(longformat_file, longest_bytesizes) }
end

def display_longformat_directory_files(files, path)
  longformat_files = files.map { |file| generate_longformat_file(file, File.absolute_path(file, path)) }
  longest_bytesizes = generate_longest_bytesizes(longformat_files)
  puts "total #{longformat_files.sum { |file| file[:blocks] }}"

  longformat_files.each { |longformat_file| puts generate_longformat_file_line(longformat_file, longest_bytesizes) }
end

def generate_longformat_file(file, file_path)
  file_stat = File::Stat.new(file_path)
  {
    filemode: filemode(file_stat),
    hardlink_nums: file_stat.nlink.to_s,
    owner_name: Etc.getpwuid(file_stat.uid).name,
    group_name: Etc.getgrgid(file_stat.gid).name,
    bytesize: file_stat.size.to_s,
    latest_modify_datetime: file_stat.mtime.strftime('%_m %e %H:%M'),
    filename: file,
    blocks: file_stat.blocks
  }
end

def filemode(file_stat)
  file_stat_mode = file_stat.mode.to_s(8).rjust(6, '0')
  special_permission = file_stat_mode[2]
  each_permissions = [
    [file_stat_mode[3], SUID_PERMISSION],
    [file_stat_mode[4], SUID_PERMISSION],
    [file_stat_mode[5], STICKEY_PERMISSION]
  ]
  each_permissions.map do |permissions|
    convert_permission(special_permission, permissions[0], permissions[1])
  end.unshift(FILE_TYPE[file_stat_mode[0, 2]]).join
end

def generate_longest_bytesizes(files)
  # hardlink_nums owner_name group_name bytesizeはファイル名の最大文字数で右詰めするため取得
  %i[hardlink_nums owner_name group_name bytesize].each_with_object({}) do |sym, hash|
    hash[sym] = files.map { |file| file[sym].to_s.bytesize }.max
  end
end

def generate_longformat_file_line(longformat_file, longest_bytesizes)
  longformat_file.map do |k, v|
    next if k == :blocks

    # filemode owner_name group_name は右隣と２スペース分空いているため空白文字を追加
    buffer_space = ' ' if %i[filemode owner_name group_name].include?(k)
    longest_bytesizes[k] ? v.rjust(longest_bytesizes[k]) + buffer_space.to_s : v + buffer_space.to_s
  end.join(' ')
end

def convert_permission(special_permission, permission, target_permission)
  return PERMISSION[permission] if special_permission != target_permission

  special_permission_character = permission.to_i.odd? ? SPECIAL_PERMISSION[special_permission] : SPECIAL_PERMISSION[special_permission].upcase
  PERMISSION[permission].chop + special_permission_character
end

main
