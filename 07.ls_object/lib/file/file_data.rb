#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'
require_relative 'file_status'

class FileData
  attr_reader :name, :file_status

  def initialize(name, path)
    @name = name
    @full_path = Pathname(File.absolute_path(@name, path))
    @file_status = build_file_status(FileStatus.new(@full_path))
  end

  private

  def build_file_status(file_status)
    {
      type_and_mode: "#{file_status.file_type}#{file_status.file_mode}",
      hardlink_nums: file_status.hardlink_nums.to_s,
      owner_name: file_status.owner_name,
      group_name: file_status.group_name,
      bytesize: file_status.bytesize.to_s,
      latest_modify_datetime: file_status.latest_modify_datetime,
      filename: @name,
      blocks: file_status.blocks
    }
  end
end
