# コマンドのインターフェース
class SortOption < Option
  def initialize(file_data, reverse)
    @reverse = reverse
    @file_data = file_data
  end

  def execute
    if @reverse
      @file_data.sort_by{|file| file.name }.reverse
    else
      @file_data.sort_by{|file| file.name }
    end
  end
end