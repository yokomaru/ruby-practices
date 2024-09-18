class CompositeOption < Option
  def initialize
    @options = []
  end

  def add_option(option)
    @options << option
  end

  def execute
    @options.each { |option| option.execute }
  end
end