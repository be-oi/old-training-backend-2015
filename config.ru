#
# This file is here to let the thin web server and apache-passenger launch the correct
# web service. We only hack the load path, require code and run the backend.
#
# For more information about config.ru, learn about Rack, which is used in all ruby web
# apps, http://rack.github.com/ or http://en.wikipedia.org/wiki/Rack_(web_server_interface)
#
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'beoi'
run BeOI::App
use Rack::PostBodyContentTypeParser
