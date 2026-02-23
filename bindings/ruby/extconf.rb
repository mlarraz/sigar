#
# Copyright (c) 2007, 2009 Hyperic, Inc.
# Copyright (c) 2009 SpringSource, Inc.
# Copyright (c) 2010-2012 VMware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'mkmf'
require 'rbconfig'

extension_name = 'sigar'

print 'Ruby platform=' + RUBY_PLATFORM + "\n"

case RUBY_PLATFORM
when /darwin/
  os = 'darwin'
  if File.file?("/usr/include/libproc.h")
    $CPPFLAGS += ' -DDARWIN_HAS_LIBPROC_H'
  end
  $CPPFLAGS += ' -DDARWIN'
  $LDFLAGS += ' -framework CoreServices -framework IOKit'
when /bsd/
  os = 'darwin'
  have_library("kvm")
when /linux/
  os = 'linux'
  if have_header("sys/sysmacros.h")
    $CPPFLAGS += ' -DLINUX_SYSMACROS'
  end
else
  raise "Unsupported platform: #{RUBY_PLATFORM}"
end

osdir = "../../src/os/#{os}"
$CPPFLAGS += ' -I../../include' + ' -I' + osdir
$CPPFLAGS += ' -U_FILE_OFFSET_BITS'

if File.exist?('Makefile')
  cmd = 'make distclean'
  print cmd + "\n"
  system(cmd)
end
Dir["./*.c"].each do |file|
  if File.lstat(file).symlink?
    print "unlink #{file}\n"
    File.delete(file)
  end
end

$distcleanfiles = ['sigar_version.c']

# Generate sigar_version.c from template
libname = extension_name + '.' + CONFIG['DLEXT']
props = {}
File.foreach("../../version.properties") do |line|
  next if line =~ /^#/ || line.strip.empty?
  key, val = line.strip.split('=', 2)
  props[key] = val
end
scm_revision = `git -C ../.. rev-parse --short HEAD 2>/dev/null`.strip
scm_revision = "unknown" if scm_revision.empty?
build_date = Time.now.strftime("%m/%d/%Y %I:%M %p")
version_string = "#{props['version.major']}.#{props['version.minor']}.#{props['version.maint']}.#{props['version.build']}"

template = File.read("../../src/sigar_version.c.in")
version_c = template
  .gsub("@@BUILD_DATE@@", build_date)
  .gsub("@@SCM_REVISION@@", scm_revision)
  .gsub("@@VERSION_STRING@@", version_string)
  .gsub("@@ARCHNAME@@", RUBY_PLATFORM)
  .gsub("@@ARCHLIB@@", libname)
  .gsub("@@BINNAME@@", libname)
  .gsub("@@VERSION_MAJOR@@", props['version.major'])
  .gsub("@@VERSION_MINOR@@", props['version.minor'])
  .gsub("@@VERSION_MAINT@@", props['version.maint'])
  .gsub("@@VERSION_BUILD@@", props['version.build'])
File.write("sigar_version.c", version_c)

(Dir["../../src/*.c"] + Dir["#{osdir}/*.c"] + Dir["#{osdir}/*.cpp"]).each do |file|
  cf = File.basename(file)
  print file + ' -> ' + cf + "\n"
  File.symlink(file, cf) unless File.file?(cf)
  $distcleanfiles.push(cf)
end

dir_config(extension_name)

create_makefile(extension_name)
