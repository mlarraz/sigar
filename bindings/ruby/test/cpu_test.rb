$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class CpuTest < Minitest::Test
  include SigarTestHelpers

  def test_cpu
    cpu = sigar.cpu
    assert_operator cpu.user, :>=, 0
    assert_operator cpu.sys, :>=, 0
    assert_operator cpu.idle, :>=, 0
    assert_operator cpu.wait, :>=, 0
    assert_operator cpu.irq, :>=, 0
    assert_operator cpu.soft_irq, :>=, 0
    assert_operator cpu.stolen, :>=, 0
    assert_operator cpu.total, :>, 0
  end

  def test_cpu_list
    list = sigar.cpu_list
    assert_kind_of Array, list
    refute_empty list

    list.each do |cpu|
      assert_operator cpu.total, :>, 0
    end
  end

  def test_cpu_info_list
    list = sigar.cpu_info_list
    assert_kind_of Array, list
    refute_empty list

    info = list.first
    refute_empty info.vendor
    refute_empty info.model
    assert_operator info.total_cores, :>, 0
  end
end
