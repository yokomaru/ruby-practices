#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'pathname'

class FileData
  attr_reader :name, :file_status

  PERMISSION_START_POSITION = 7
  PERMISSION_END_POSITION = 9

  FILE_TYPE = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  SPECIAL_PERMISSION = {
    0 => 's',
    1 => 's',
    2 => 't'
  }.freeze

  PERMISSION_TYPE = {
    '000' => '---',
    '001' => '--x',
    '010' => '-w-',
    '011' => '-wx',
    '100' => 'r--',
    '101' => 'r-x',
    '110' => 'rw-',
    '111' => 'rwx'
  }.freeze

  def initialize(name, path)
    @name = name
    @full_path = Pathname(File.absolute_path(@name, path))
    @file_type = File.ftype(@full_path)
    @file_status = build_file_status(File.lstat(@full_path))
  end

  private

  def build_file_status(status)
    {
      type: FILE_TYPE[status.ftype],
      mode: mode(status),
      hardlink_nums: status.nlink.to_s,
      owner_name: Etc.getpwuid(status.uid).name,
      group_name: Etc.getgrgid(status.gid).name,
      bytesize: rdev_or_bytesize(status),
      latest_modify_datetime: status.mtime.strftime('%_m %e %H:%M'),
      filename: file_name(status),
      blocks: status.blocks
    }
  end

  def file_name(status)
    status.symlink? ? "#{@name} -> #{File.readlink(@full_path)}" : @name
  end

  def mode(status)
    mode_binary_numbers = status.mode.to_s(2).rjust(16, '0')
    # SUID、SGID、STICKEYBITの順番で特殊権限をチェック
    mode_binary_numbers[4..6].each_char.with_index.map do |special_permission, i|
      range_start = PERMISSION_START_POSITION + (3 * i)
      range_end = PERMISSION_END_POSITION + (3 * i)
      permission = PERMISSION_TYPE[mode_binary_numbers[range_start..range_end]].dup
      permission[2] = permission[2] == 'x' ? SPECIAL_PERMISSION[i] : SPECIAL_PERMISSION[i].upcase if special_permission == '1'
      permission
    end.join
  end

  def rdev_or_bytesize(status)
    %w[characterSpecial blockSpecial].include?(@file_type) ? format('%#01x', status.rdev.to_s(10)) : status.size.to_s
  end
end
