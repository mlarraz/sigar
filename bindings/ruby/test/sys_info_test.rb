$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class SysInfoTest < Minitest::Test
  include SigarTestHelpers

  def test_sys_info
    info = sigar.sys_info
    refute_empty info.name
    refute_empty info.version
    refute_empty info.arch
    refute_empty info.vendor
    refute_empty info.vendor_name
  end

  def test_resource_limit
    limit = sigar.resource_limit
    assert_operator limit.open_files_cur, :>, 0
  end

  def test_format_size
    assert_match(/1.*K/, Sigar.format_size(1024))
    assert_match(/1.*M/, Sigar.format_size(1024 * 1024))
  end

  def test_version_constants
    refute_empty Sigar::VERSION
    refute_empty Sigar::BUILD_DATE
    refute_empty Sigar::SCM_REVISION
  end
end
