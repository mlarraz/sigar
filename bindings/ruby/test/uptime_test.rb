$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class UptimeTest < Minitest::Test
  include SigarTestHelpers

  def test_uptime
    uptime = sigar.uptime
    assert_operator uptime.uptime, :>, 0
  end
end
