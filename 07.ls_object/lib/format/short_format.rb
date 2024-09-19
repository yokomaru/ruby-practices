# frozen_string_literal: true

require_relative 'format'

class ShortFormat < Format
  def initialize(files, width)
    super(files)
    @width = width
    @max_file_name = @files.map { |file| File.basename(file.name).size }.max
    @col_count = calculate_col_count
    @row_count = calculate_row_count
    @short_format_data = build_short_format_data
  end

  def render
    @short_format_data.join("\n")
  end

  private

  def build_short_format_data
    safe_transpose.map { |row_files| build_short_format_row(row_files) }
  end

  def build_short_format_row(row_files)
    row_files.map do |files|
      basename = files ? File.basename(files.name) : ''
      basename.ljust(@max_file_name + 1)
    end.join.rstrip
  end

  def calculate_col_count
    @width / (@max_file_name + 1)
  end

  def calculate_row_count
    @col_count.zero? ? @files.count : (@files.count.to_f / @col_count).ceil
  end

  def safe_transpose
    nested_file_names = @files.each_slice(@row_count).to_a
    nested_file_names[0].zip(*nested_file_names[1..])
  end
end
