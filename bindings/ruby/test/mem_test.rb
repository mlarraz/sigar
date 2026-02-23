$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class MemTest < Minitest::Test
  include SigarTestHelpers

  def test_mem
    mem = sigar.mem
    assert_operator mem.total, :>, 0
    assert_operator mem.used, :>, 0
    assert_operator mem.free, :>, 0
    assert_operator mem.actual_used, :>, 0
    assert_operator mem.actual_free, :>, 0
    assert_operator mem.ram, :>, 0
    assert_equal 0, mem.ram % 8

    assert_operator mem.used_percent, :>, 0
    assert_operator mem.used_percent, :<=, 100

    assert_operator mem.free_percent, :>=, 0
    assert_operator mem.free_percent, :<, 100
  end
end
