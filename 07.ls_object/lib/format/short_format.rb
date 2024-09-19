# frozen_string_literal: true

require_relative 'format'

class ShortFormat < Format
  def initialize(files, width)
    super(files)
    @width = width
    @max_file_name = @files.map { |f| File.basename(f.name).size }.max
    @col_count = calculate_col_count
    @row_count = calculate_row_count
  end

  def render
    format_table(safe_transpose)
  end

  private

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

  def format_table(file_paths)
    file_paths.map { |row_files| render_short_format_row(row_files) }.join("\n")
  end

  def render_short_format_row(row_files)
    row_files.map do |file_path|
      basename = file_path ? File.basename(file_path.name) : ''
      basename.ljust(@max_file_name + 1)
    end.join.rstrip
  end
end
