#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'debug'

class FileStatus
  SPECIAL_PERMISSION_INDEX = 2
  OWNER_PERMISSION_INDEX = 3
  GROUP_PERMISSION_INDEX = 4
  OTHER_PERMISSION_INDEX = 5

  FILE_TYPE = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }.freeze

  PERMISSION_TYPE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  SPECIAL_PERMISSION_TYPE = {
    '0' => '-',
    '1' => 't',
    '2' => 's',
    '4' => 's'
  }.freeze

  TARGET_SPECIAL_PERMISSION = {
    OWNER_PERMISSION_INDEX => '2',
    GROUP_PERMISSION_INDEX => '4',
    OTHER_PERMISSION_INDEX => '1'
  }.freeze

  attr_reader :name, :file_status

  def initialize(file_name, path)
    @file_name = file_name
    @status = File::Stat.new(File.absolute_path(file_name, path))
    @filemode = filemode(@status)
    @hardlink_nums = @status.nlink
    @owner_name = Etc.getpwuid(@status.uid).name
    @group_name = Etc.getgrgid(@status.gid).name
    @bytesize = @status.size
    @latest_modify_datetime = @status.mtime.strftime('%_m %e %H:%M')
    @blocks = @status.blocks
  end

  def build_file_status
    {
      filemode: @filemode,
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
  # リファクタする
  def filemode(status)
    mode = status.mode.to_s(8).rjust(6, '0')
    [OWNER_PERMISSION_INDEX, GROUP_PERMISSION_INDEX, OTHER_PERMISSION_INDEX].map do |index|
      convert_permission(mode[index],
                        mode[SPECIAL_PERMISSION_INDEX],
                        TARGET_SPECIAL_PERMISSION[index])
                        end.unshift(FILE_TYPE[
                        mode[0, SPECIAL_PERMISSION_INDEX]])
                        .join
  end

  # リファクタする
  def convert_permission(permission, special_permission, target_special_permission)
    permission_type = PERMISSION_TYPE[permission]
    return permission_type if special_permission != target_special_permission

    special_permission_type = SPECIAL_PERMISSION_TYPE[special_permission]

    special_permission_type = special_permission_type.upcase if permission.to_i.even?

    [permission_type.chop, special_permission_type].join
  end
end
