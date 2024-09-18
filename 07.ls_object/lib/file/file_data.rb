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

  def display_file_status
    @file_status.reject { |key| key == :blocks }.map do |key, value| # blocksは表示には使用しないため表示の配列から除く
      value
    end.join(' ')
  end
end
