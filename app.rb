require 'sinatra'
require 'sinatra/assetpack'
require 'open-uri'
require 'json'

require_relative './playlist'
require_relative './station_parser'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/css', {:from => 'assets/css'}
    serve '/js',  {:from => 'assets/js'}
    #serve '/images', {:from => 'assets/images'}

    css :app, ['css/normalize.css', 'css/app.css']
    js  :app, ['js/app.js', 'js/controllers.js', 'js/services.js', 'js/directives.js']
  }

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  get '/' do
    erb :index
  end

  get '/best_station' do
    content_type :json
    api_params = {:apiKey => ENV['API_KEY']}

    if params['zipcode']
      api_params[:zip] = params['zipcode']
    else
      api_params[:lon] = params['longitude']
      api_params[:lat] = params['latitude']
    end

    api_params_encoded = ::URI.encode_www_form(api_params)
    api_response = open("http://api.npr.org/stations?#{api_params_encoded}").read
    station_parser = StationParser.new(:stations_xml => api_response)

    station_parser.get_strongest_station.to_json
  end

  get '/listen' do
    # return if an actual audio file url
    unless params[:url] =~ /.pls|.m3u*\b/i
      return params[:url]
    end

    playlist_body = open(params[:url]).read
    playlist = Playlist.new( :body => playlist_body, :filetype => params[:url] =~ /.pls\b/i ? :pls : :m3u )

    playlist.get_stream_url
  end
end

