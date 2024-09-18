# コマンドのインターフェース
class FormatOption < Option
  attr_reader :description
  def initialize(file_data, long_format)
    @long_format = long_format
    @file_data = file_data
  end

  def execute
    if @long_format
      ["total #{@file_data.sum { |status| status.file_status[:blocks] }}"]
      .concat(@file_data.map(&:display_file_status))
      .join("\n")
    else
      @file_data.map(&:name).join(' ')
    end
  end
end