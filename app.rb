require 'sinatra/base'

class JpnBible < Sinatra::Base
  BOOKS =
    # old
    %w[
      gen exod lev num deut josh judg ruth 1sam 2sam 1kgs 2kgs 1chr 2chr ezra neh esth job ps
      prov eccl song isa jer lam ezek dan hos joel amos obad jonah mic nah hab zeph hag zech mal
    ] +
    # new
    %w[
      matt mark luke john acts rom 1cor 2cor gal eph phil col 1thess 2thess 1tim 2tim titus phlm
      heb jas 1pet 2pet 1john 2john 3john jude rev
    ]

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  def self.get_book(prefix)
    BOOKS.each do |book|
      path = [prefix, book].join('/')

      %w[htm html xhtml].each do |ext|
        get "#{path}.#{ext}" do
          redirect path, 301
        end
      end

      get path do
        send_file "bibles#{path}.html", type: :html
      end
    end
  end

  get '/' do
    redirect '/kougo/'
  end

  get_book '/kougo'
end
