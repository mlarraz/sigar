require "minitest/autorun"
require "sigar"

module SigarTestHelpers
  def sigar
    @sigar ||= Sigar.new
  end
end
