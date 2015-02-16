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

require_relative 'beoi/config'
require_relative 'beoi/auth'
require_relative 'beoi/helpers/init'
require_relative 'beoi/app/init'
require_relative 'beoi/routes/init'
require_relative 'beoi/database/init'

module BeOI

  extend Config
  extend Auth

  DB = BeOI.sequel_db

end


