require 'rubygems'
require 'sinatra'
require 'bundler'
require 'json'
require 'sequel'
require 'path'
require 'logger'
require 'rack'
require 'rack/contrib'

$: << File.expand_path('../', __FILE__)

Bundler.require

require_relative 'BeOI/config'
require_relative 'BeOI/auth'
require_relative 'BeOI/helpers/init'
require_relative 'BeOI/app/init'
require_relative 'BeOI/routes/init'
require_relative 'BeOI/database/init'

module BeOI

  extend Config
  extend Auth

  DB = BeOI.sequel_db

end


