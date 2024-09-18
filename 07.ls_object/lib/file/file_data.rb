#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'debug'
require_relative 'file_status'

class FileData
  attr_reader :name, :file_status

  def initialize(file_name, path)
    @name = file_name
    @path = path
    @file_status = FileStatus.new(@name, @path).build_file_status
  end
end
