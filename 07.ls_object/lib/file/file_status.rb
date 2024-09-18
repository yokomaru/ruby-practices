#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'debug'
require 'pathname'

class FileStatus
  MODE_TABLE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  attr_reader :file_name, :file_status

  def initialize(file_name, path)
    @file_name = file_name
    @pathname = Pathname(File.absolute_path(@file_name, path))
    @status = File::Stat.new(@pathname)
    @file_type = format_file_type
    @file_mode = format_file_mode
    @hardlink_nums = @status.nlink
    @owner_name = Etc.getpwuid(@status.uid).name
    @group_name = Etc.getgrgid(@status.gid).name
    @bytesize = @status.size
    @latest_modify_datetime = @status.mtime.strftime('%_m %e %H:%M')
    @blocks = @status.blocks
  end

  def build_file_status
    {
      type_and_mode: "#{@file_type}#{@file_mode}",
      hardlink_nums: @hardlink_nums,
      owner_name: @owner_name,
      group_name: @group_name,
      bytesize: @bytesize,
      latest_modify_datetime: @latest_modify_datetime,
      filename: @file_name,
      blocks: @blocks
    }
  end

  private

  def format_file_type
    @pathname.directory? ? 'd' : '-'
  end

  def format_file_mode
    @pathname.stat.mode.to_s(8)[-3..-1].gsub(/./, MODE_TABLE)
  end
end
