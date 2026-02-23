$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class NetworkTest < Minitest::Test
  include SigarTestHelpers

  def test_net_interface_list
    list = sigar.net_interface_list
    assert_kind_of Array, list
    refute_empty list
    assert list.all? { |name| name.is_a?(String) }
  end

  def test_net_interface_config
    iface = sigar.net_interface_list.first
    config = sigar.net_interface_config(iface)
    refute_empty config.name
    refute_empty config.type
  end

  def test_net_interface_stat
    iface = sigar.net_interface_list.first
    stat = sigar.net_interface_stat(iface)
    assert_operator stat.rx_bytes, :>=, 0
    assert_operator stat.tx_bytes, :>=, 0
    assert_operator stat.rx_packets, :>=, 0
    assert_operator stat.tx_packets, :>=, 0
  end

  def test_net_info
    info = sigar.net_info
    refute_nil info.host_name
  end

  def test_net_route_list
    list = sigar.net_route_list
    assert_kind_of Array, list
  end

  def test_fqdn
    fqdn = sigar.fqdn
    assert_kind_of String, fqdn
    refute_empty fqdn
  end

  def test_tcp
    tcp = sigar.tcp
    assert_operator tcp.retrans_segs, :>=, 0
  end
end
