# frozen_string_literal: true

require_relative 'option'
require 'pathname'
class FormatOption < Option
  def initialize(files, option, total_block, width)
    super(files, option)
    @total_block = total_block
    @width = width
  end

  def execute
    if @option
      ls_long
    else
      ls_short
    end
  end

  private

  def ls_short
    max_file_path_count = @files.map { |f| File.basename(f.name).size }.max
    col_count = @width / (max_file_path_count + 1)
    row_count = col_count.zero? ? @files.count : (@files.count.to_f / col_count).ceil
    transposed_file_paths = safe_transpose(@files.each_slice(row_count).to_a)
    format_table(transposed_file_paths, max_file_path_count)
  end

  def safe_transpose(nested_file_names)
    nested_file_names[0].zip(*nested_file_names[1..])
  end

  def format_table(file_paths, max_file_path_count)
    file_paths.map do |row_files|
      render_short_format_row(row_files, max_file_path_count)
    end.join("\n")
  end

  def render_short_format_row(row_files, max_file_path_count)
    row_files.map do |file_path|
      basename = file_path ? File.basename(file_path.name) : ''
      basename.ljust(max_file_path_count + 1)
    end.join.rstrip
  end

  def ls_long
    total = "total #{@total_block}"
    body = render_long_format_body
    [total, *body].join("\n")
  end

  def render_long_format_body
    max_sizes = %i[hardlink_nums owner_name group_name bytesize].map do |key|
      find_max_size(key)
    end
    @files.map do |data|
      format_row(data.file_status, *max_sizes)
    end
  end

  def find_max_size(key)
    @files.map { |data| data.file_status[key].size }.max
  end

  def format_row(data, max_nlink, max_user, max_group, max_size)
    [
      data[:type_and_mode],
      "  #{data[:hardlink_nums].rjust(max_nlink)}",
      " #{data[:owner_name].ljust(max_user)}",
      "  #{data[:group_name].ljust(max_group)}",
      "  #{data[:bytesize].rjust(max_size)}",
      " #{data[:latest_modify_datetime]}",
      " #{data[:filename]}"
    ].join
  end
end
