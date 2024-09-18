#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'debug'

class FileData
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

  def initialize(file, path)
    @name = file
    @path = path
    @file_status = generate_file_status
    @max_bitesize = {}
  end

  def generate_file_status
    status = File::Stat.new(File.absolute_path(@name, @path))
    {
      filemode: filemode(status),
      hardlink_nums: status.nlink.to_s,
      owner_name: Etc.getpwuid(status.uid).name,
      group_name: Etc.getgrgid(status.gid).name,
      bytesize: status.size.to_s,
      latest_modify_datetime: status.mtime.strftime('%_m %e %H:%M'),
      filename: @name,
      blocks: status.blocks
    }
  end

  # リファクタする
  def display_file_status()
    @file_status.reject { |key| key == :blocks }.map do |key, value| # blocksは表示には使用しないため表示の配列から除く
      value
    end.join(' ')
  end

  # リファクタする
  def filemode(status)
    mode = status.mode.to_s(8).rjust(6, '0')
    [OWNER_PERMISSION_INDEX, GROUP_PERMISSION_INDEX, OTHER_PERMISSION_INDEX].map do |index|
      convert_permission(mode[index], mode[SPECIAL_PERMISSION_INDEX], TARGET_SPECIAL_PERMISSION[index])
    end.unshift(FILE_TYPE[mode[0, SPECIAL_PERMISSION_INDEX]]).join
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
