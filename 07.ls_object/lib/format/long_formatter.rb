# frozen_string_literal: true

require_relative 'formatter'

class LongFormatter < Formatter
  def initialize(files)
    super(files)
    @max_sizes = build_max_sizes
    @total_block = sum_blocks
    @long_format_data = build_long_format_data
  end

  def format
    total = "total #{@total_block}"
    [total, *@long_format_data].join("\n")
  end

  private

  def build_long_format_data
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

  def format_row(status, max_nlink, max_user, max_group, max_size)
    [
      status[:type_and_mode],
      "  #{status[:hardlink_nums].rjust(max_nlink)}",
      " #{status[:owner_name].ljust(max_user)}",
      "  #{status[:group_name].ljust(max_group)}",
      "  #{status[:bytesize].rjust(max_size)}",
      " #{status[:latest_modify_datetime]}",
      " #{status[:filename]}"
    ].join
  end

  def sum_blocks
    @files.sum { |file| file.file_status[:blocks] }
  end
end
