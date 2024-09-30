# frozen_string_literal: true

require_relative 'file/file_data'
require_relative 'format/long_format'
require_relative 'format/short_format'

class LsCommand
  def initialize(path, width: 80, dot_match: false, reverse: false, long_format: false)
    @path = path
    @width = width
    @dot_match = dot_match
    @reverse = reverse
    @long_format = long_format
    @files = build_files
  end

  def display
    @long_format ? LongFormat.new(@files).render : ShortFormatter.new(@files, @width).render
  end

  private

  def build_files
    files = Dir.open(@path).entries.map { |name| FileData.new(name, @path) }
    matched_files = @dot_match ? files : files.filter { |file| !/^\./.match?(file.name) }
    @reverse ? matched_files.sort_by(&:name).reverse : matched_files.sort_by(&:name)
  end
end
