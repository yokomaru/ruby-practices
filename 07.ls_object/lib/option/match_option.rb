# frozen_string_literal: true

require_relative 'option'
class MatchOption < Option
  def execute
    @option ? @files : @files.filter { |file| !/^\./.match?(file.name) }
  end
end
