$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class FileSystemTest < Minitest::Test
  include SigarTestHelpers

  def test_file_system_list
    list = sigar.file_system_list
    assert_kind_of Array, list
    refute_empty list

    list.each do |fs|
      refute_empty fs.dev_name
      refute_empty fs.dir_name
      refute_empty fs.type_name
      refute_empty fs.sys_type_name
    end
  end

  def test_file_system_usage
    fs = sigar.file_system_list.find { |f| f.type == Sigar::FSTYPE_LOCAL_DISK }
    skip "no local disk found" unless fs

    usage = sigar.file_system_usage(fs.dir_name)
    assert_operator usage.total, :>, 0
    assert_operator usage.used, :>=, 0
    assert_operator usage.avail, :>=, 0
    assert_operator usage.use_percent, :>=, 0
    assert_operator usage.use_percent, :<=, 100
  end
end
