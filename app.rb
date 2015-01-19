require "json"
require "dotenv"
require "sinatra"
require "sinatra/assetpack"
require "yui/compressor"
require "sass"

class App < Sinatra::Base
  register Sinatra::AssetPack

  configure :development do
    register Sinatra::Reloader
  end

  assets {
    serve "/css", {:from => "assets/css"}
    serve "/js",  {:from => "assets/js"}
    #serve "/images", {:from => "assets/images"}

    css :app, ["css/app.css"]

    css_compression :yui
    #js_compression  :uglify
  }

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  get "/" do
    erb :index
  end

  get "/stations/strongest" do
    content_type :json

    strongest_station = StationFinder.find_strongest_station(coordinates)
    strongest_station.to_json unless strongest_station.nil?
  end

  get "/stations/listen" do
    # do nothing if URL already points to an audio file (and not a playlist)
    unless params[:url] =~ /.pls|.m3u*\b/i
      return params[:url]
    end

    playlist = Playlist.new( :url => params[:url] )
    playlist.get_stream_url
  end
end
