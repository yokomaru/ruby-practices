#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'pathname'

class FileData
  attr_reader :name, :file_status

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

  def initialize(name, path)
    @name = name
    @full_path = Pathname(File.absolute_path(@name, path))
    @file_status = build_file_status(File::Stat.new(@full_path))
  end

  private

  def build_file_status(status)
    {
      type_and_mode: "#{format_file_type}#{format_file_mode}",
      hardlink_nums: status.nlink.to_s,
      owner_name: Etc.getpwuid(status.uid).name,
      group_name: Etc.getgrgid(status.gid).name,
      bytesize: status.size.to_s,
      latest_modify_datetime: status.mtime.strftime('%_m %e %H:%M'),
      filename: @name,
      blocks: status.blocks
    }
  end

  def format_file_type
    @full_path.directory? ? 'd' : '-'
  end

  def format_file_mode
    @full_path.stat.mode.to_s(8)[-3..].gsub(/./, MODE_TABLE)
  end
end
