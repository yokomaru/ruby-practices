#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

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

  attr_reader :file_type, :file_mode, :hardlink_nums, :owner_name, :group_name, :bytesize, :latest_modify_datetime, :blocks

  def initialize(path)
    @status = File::Stat.new(path)
    @file_type = format_file_type(path)
    @file_mode = format_file_mode(path)
    @hardlink_nums = @status.nlink
    @owner_name = Etc.getpwuid(@status.uid).name
    @group_name = Etc.getgrgid(@status.gid).name
    @bytesize = @status.size
    @latest_modify_datetime = @status.mtime.strftime('%_m %e %H:%M')
    @blocks = @status.blocks
  end

  private

  def format_file_type(path)
    path.directory? ? 'd' : '-'
  end

  def format_file_mode(path)
    path.stat.mode.to_s(8)[-3..].gsub(/./, MODE_TABLE)
  end
end
