# frozen_string_literal: true

require 'debug'
require 'pathname'
require_relative 'ls_file'

class LsCommand
  def initialize(path, dot_match: false, reverse: false)
    @path = path
    @dot_match = dot_match
    @reverse = reverse
    @ls_files = Dir.open(@path).entries.map { |file| LsFile.new(file) }
    @matched_files = dot_match_files
    @sorted_ls_files = sort_files
  end

  def display
    @sorted_ls_files.map(&:name).join(' ')
  end

  private

  def dot_match_files
    if @dot_match
      @ls_files
    else
      @ls_files.filter { |file| !/^\./.match?(file.name) }
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
