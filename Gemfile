source 'https://rubygems.org'

ruby '~> 2.5.1' if ENV['DYNO']

gem 'sinatra'
gem 'puma'

group :development, :test do
  gem 'sinatra-contrib'
  gem 'test-unit'
  gem 'rake'
  gem 'osis2html5', '0.1.0', path: '../osis2html5' unless ENV['DYNO']
end
