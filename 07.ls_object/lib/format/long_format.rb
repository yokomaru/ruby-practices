# frozen_string_literal: true

require_relative 'format'

class LongFormat < Format
  def initialize(files, total_block)
    super(files)
    @total_block = total_block
    @max_sizes = build_max_sizes
    @long_format_data = build_long_format
  end

  def render
    total = "total #{@total_block}"
    [total, *@long_format_data].join("\n")
  end

  private

  def build_long_format
    @files.map { |file| format_row(file.file_status, *@max_sizes) }
  end

  def build_max_sizes
    %i[hardlink_nums owner_name group_name bytesize].map do |key|
      find_max_size(key)
    end
  end

  def find_max_size(key)
    @files.map { |file| file.file_status[key].size }.max
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
