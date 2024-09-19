# frozen_string_literal: true

require_relative 'option'

class SortOption < Option
  def execute
    @option ? @files.sort_by(&:name).reverse : @files.sort_by(&:name)
  end
end
