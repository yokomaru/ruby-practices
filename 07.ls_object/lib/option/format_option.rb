# frozen_string_literal: true

require_relative 'option'
require_relative '../format/long_format'
require_relative '../format/short_format'

class FormatOption < Option
  def initialize(files, option, width)
    super(files, option)
    @width = width
  end

  def execute
    if @option
      LongFormat.new(@files).render
    else
      ShortFormat.new(@files, @width).render
    end
  end
end
