#!/usr/bin/env ruby
# frozen_string_literal: true
require 'debug'

class LsFile
  attr_reader :name

  def initialize(file)
    @name = file
  end

  def file_format?
    File.file?(arg)
  end
end