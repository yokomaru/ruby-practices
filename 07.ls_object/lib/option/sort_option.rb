# frozen_string_literal: true

require_relative 'option'
class SortOption < Option
  def execute
    if @option
      @files.sort_by(&:name).reverse
    else
      @files.sort_by(&:name)
    end
  end
end
