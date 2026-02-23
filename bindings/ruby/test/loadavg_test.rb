$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class LoadAvgTest < Minitest::Test
  include SigarTestHelpers

  def test_loadavg
    loadavg = sigar.loadavg
    assert_equal 3, loadavg.length
    loadavg.each { |v| assert_operator v, :>=, 0 }
  end
end
