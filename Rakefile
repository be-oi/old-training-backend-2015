$:.unshift File.expand_path('../lib', __FILE__)
require 'beoi'
include BeOI::Config

# We run tests by default
task :test    => :'test:all'
task :default => :test

#
# Install all tasks found in tasks folder
#
# See .rake files there for complete documentation.
#
Dir["tasks/*.rake"].each do |taskfile|
  load taskfile
end
