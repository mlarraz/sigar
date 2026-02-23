$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class SwapTest < Minitest::Test
  include SigarTestHelpers

  def test_swap
    swap = sigar.swap
    assert_operator swap.total, :>=, 0
    assert_operator swap.used, :>=, 0
    assert_operator swap.free, :>=, 0
  end
end
