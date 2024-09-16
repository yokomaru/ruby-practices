# frozen_string_literal: true

require 'debug'
require 'pathname'
require_relative 'file_data'

class LsCommand
  def initialize(path, dot_match: false, reverse: false)
    @path = path
    @dot_match = dot_match
    @reverse = reverse
    @file_data = Dir.open(@path).entries.map { |file| FileData.new(file) }
    @matched_files = dot_match_files
    @sorted_file_data = sort_files
  end

  def display
    @sorted_file_data.map(&:name).join(' ')
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
