$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class SmokeTest < Minitest::Test
  # Exercises every no-arg method on Sigar.new to catch segfaults and
  # link errors. Doesn't validate values — just that they don't crash.

  NO_ARG_METHODS = %i[
    cpu cpu_list cpu_info_list loadavg mem swap uptime
    file_system_list net_interface_list net_route_list
    arp_list who_list proc_list proc_stat fqdn
    net_info sys_info resource_limit tcp
    dump_pid_cache
  ].freeze

  def test_no_arg_methods_do_not_crash
    s = Sigar.new
    NO_ARG_METHODS.each do |method|
      assert s.respond_to?(method), "Sigar should respond to #{method}"
      begin
        s.send(method)
      rescue ArgumentError, RuntimeError => e
        # Some methods may fail on certain OSes (e.g., NFS stats).
        # That's fine — we're testing they don't segfault.
        pass
      end
    end
  end
end
