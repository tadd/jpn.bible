require 'sinatra/base'

class JpnBible < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  # renders /public
end
