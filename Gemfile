source "https://rubygems.org"
ruby '1.9.3'

group :runtime do
  gem 'sinatra'
  gem 'rake'
  gem 'json'
  gem 'sequel'
  gem 'path'
  gem 'pg'
  gem 'rack-contrib'
  
  # Google authentication (token verification)
  gem 'jwt', '~> 0.1.5' # for google-api-client (v1.0.0 fails)
  # gem 'google-api-client', :require => 'google/api_client'
  # gem 'google-id-token'
end

group :development do
  gem "thin"
  gem "rspec"
  gem "cucumber"
end
