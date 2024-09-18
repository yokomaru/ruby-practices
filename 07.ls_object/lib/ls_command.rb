# frozen_string_literal: true

require 'debug'
require 'pathname'
require_relative 'file_data'

class LsCommand
  def initialize(path, dot_match: false, reverse: false, long_format: false)
    @path = path
    @dot_match = dot_match
    @reverse = reverse
    @long_format = long_format
    @file_data = Dir.open(@path).entries.map { |file| FileData.new(file, @path) }
    @matched_files = dot_match_files
    @sorted_file_data = sort_files
  end

  def display
    if @long_format
      ["total #{@sorted_file_data.sum { |status| status.file_status[:blocks] }}"]
      .concat(@sorted_file_data.map(&:display_file_status))
      .join("\n")
    else
      @sorted_file_data.map(&:name).join(' ')
    end
  end

  private

  def dot_match_files
    if @dot_match
      @file_data
    else
      @file_data.filter { |file| !/^\./.match?(file.name) }
    end
  end

  def sort_files
    if @reverse
      @matched_files.sort_by{|file| file.name }.reverse
    else
      @matched_files.sort_by{|file| file.name }
    end
  end
end
