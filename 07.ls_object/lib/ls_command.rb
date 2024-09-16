#!/usr/bin/env ruby
# frozen_string_literal: true
require 'debug'
require 'pathname'
require_relative 'ls_file'

class LsCommand

  def initialize(path)
    @path = path
    @ls_files = Dir.open(@path).children.each {|file| LsFile.new(file) }.sort
  end

  def display
    @ls_files.join(" ")
  end
end
