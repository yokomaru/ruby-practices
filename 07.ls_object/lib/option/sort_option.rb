require_relative 'option'
class SortOption < Option
  def execute
    if @option
      @files.sort_by{|file| file.name }.reverse
    else
      @files.sort_by{|file| file.name }
    end
  end
end