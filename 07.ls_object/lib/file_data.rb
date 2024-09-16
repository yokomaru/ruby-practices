#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

class FileData
  attr_reader :name

  def initialize(file)
    @name = file
  end
end
