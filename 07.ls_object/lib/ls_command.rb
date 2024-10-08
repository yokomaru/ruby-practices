# frozen_string_literal: true

require_relative 'file/file_data'
require_relative 'format/long_formatter'
require_relative 'format/short_formatter'

class LsCommand
  def initialize(path, width: 80, dot_match: false, reverse: false, long_format: false)
    @path = path
    @width = width
    @dot_match = dot_match
    @reverse = reverse
    @long_format = long_format
    @files = build_dot_match_and_sorted_files
  end

  def formatted_output
    @long_format ? LongFormatter.new(@files, @path).format : ShortFormatter.new(@files, @width).format
  end

  private

  def build_dot_match_and_sorted_files
    files = generate_files
    matched_files = @dot_match ? files : files.filter { |file| !/^\./.match?(file.name) }
    @reverse ? matched_files.sort_by(&:name).reverse : matched_files.sort_by(&:name)
  end

  def generate_files
    if File.directory?(@path)
      Dir.open(@path).entries.map { |name| FileData.new(name, @path) }
    else
      [FileData.new(@path, File.dirname(@path))]
    end
  end
end
