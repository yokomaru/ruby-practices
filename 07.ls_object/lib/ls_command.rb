# frozen_string_literal: true

require 'debug'
require 'pathname'
require_relative 'file_data'
require_relative 'option/option'
require_relative 'option/composit_option'
require_relative 'option/match_option'
require_relative 'option/format_option'
require_relative 'option/sort_option'

class LsCommand
  def initialize(path, dot_match: false, reverse: false, long_format: false)
    @path = path
    @dot_match = dot_match
    @reverse = reverse
    @long_format = long_format
    @file_data = Dir.open(@path).entries.map { |name| FileData.new(name, @path) }
    @command_list = CompositeOption.new
    @matched_files = dot_match_files
    @sorted_files = sort_files
    @formated_files = format_files
  end

  def display
    @formated_files
  end

  def build_files
    @command_list.add_option(MatchOption.new(@file_data, @dot_match))
    @command_list.add_option(SortOption.new(@file_data, @reverse))
    @command_list.add_option(FormatOption.new(@file_data, @long_format))
    p @command_list.execute
  end

  private

  def format_files
    if @long_format
      ["total #{@sorted_files.sum { |status| status.file_status[:blocks] }}"]
      .concat(@sorted_files.map(&:display_file_status))
      .join("\n")
    else
      @sorted_files.map(&:name).join(' ')
    end
  end

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
