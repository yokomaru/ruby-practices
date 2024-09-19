# frozen_string_literal: true

require 'debug'
require_relative 'file/file_data'
require_relative 'option/match_option'
require_relative 'option/format_option'
require_relative 'option/sort_option'

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
    FormatOption.new(@files, @long_format, @width).execute
  end

  private

  def build_files
    files = Dir.open(@path).entries.map { |name| FileData.new(name, @path) }
    matched_files = MatchOption.new(files, @dot_match).execute
    SortOption.new(matched_files, @reverse).execute
  end
end
