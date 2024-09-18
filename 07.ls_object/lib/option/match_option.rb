# コマンドのインターフェース
class MatchOption < Option

  def initialize(file_data, dot_match)
    @dot_match = dot_match
    @file_data = file_data
  end

  def execute
    if @dot_match
      @file_data
    else
      @file_data.filter { |file| !/^\./.match?(file.name) }
    end
  end
end