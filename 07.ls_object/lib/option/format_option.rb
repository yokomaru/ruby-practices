require_relative 'option'
class FormatOption < Option

  def initialize(file, option, total_block)
    super(file, option)
    @total_block = total_block
  end

  def execute
    if @option
      ["total #{@total_block}"].concat(@files.map(&:display_file_status)).join("\n")
    else
      @files.map(&:name).join(' ')
    end
  end
end