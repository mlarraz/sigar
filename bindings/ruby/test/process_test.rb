$LOAD_PATH.unshift File.dirname(__FILE__)
require "helper"

class ProcessTest < Minitest::Test
  include SigarTestHelpers

  def test_proc_list
    list = sigar.proc_list
    assert_kind_of Array, list
    refute_empty list
    assert list.all? { |pid| pid.is_a?(Integer) }
    assert_includes list, Process.pid
  end

  def test_proc_state
    state = sigar.proc_state(Process.pid)
    refute_empty state.name
    assert_operator state.ppid, :>, 0
    assert_operator state.threads, :>, 0
  end

  def test_proc_mem
    mem = sigar.proc_mem(Process.pid)
    assert_operator mem.resident, :>, 0
    assert_operator mem.size, :>, 0
  end

  def test_proc_time
    time = sigar.proc_time(Process.pid)
    assert_operator time.start_time, :>, 0
  end

  def test_proc_args
    args = sigar.proc_args(Process.pid)
    assert_kind_of Array, args
  end

  def test_proc_env
    env = sigar.proc_env(Process.pid)
    assert_kind_of Hash, env
    refute_empty env
  end

  def test_proc_exe
    exe = sigar.proc_exe(Process.pid)
    refute_empty exe.name
  end

  def test_proc_cred_name
    cred = sigar.proc_cred_name(Process.pid)
    refute_empty cred.user
    refute_empty cred.group
  end

  def test_proc_stat
    stat = sigar.proc_stat
    assert_operator stat.total, :>, 0
  end
end
