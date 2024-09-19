# frozen_string_literal: true

require_relative 'option'
require_relative '../format/long_format'
require_relative '../format/short_format'

class FormatOption < Option
  def initialize(files, option, total_block, width)
    super(files, option)
    @total_block = total_block
    @width = width
  end

  def execute
    if @option
      LongFormat.new(@files, @total_block).render
    else
      ShortFormat.new(@files, @width).render
    end
  end
end
