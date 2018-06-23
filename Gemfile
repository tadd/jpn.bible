source 'https://rubygems.org'

ruby '~> 2.5.1' if ENV['DYNO']

gem 'sinatra'
gem 'puma'

group :development, :test do
  gem 'sinatra-contrib'
  gem 'test-unit'
  gem 'rake'
  install_if -> { !ENV.key?('DYNO') } do
    gem 'osis2html5', path: '../osis2html5'
  end
end
