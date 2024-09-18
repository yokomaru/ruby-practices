require_relative 'option'
class MatchOption < Option
  def execute
    if @option
      @files
    else
      @files.filter { |file| !/^\./.match?(file.name) }
    end
  end
end