require_relative 'app'

use Rack::Static, urls: {'/kougo/' => '/kougo/index.html'}, root: 'bibles'
run JpnBible
