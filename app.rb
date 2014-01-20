require 'sinatra'
require 'sinatra/assetpack'
require 'open-uri'
require 'json'
require 'xmlsimple'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/css', {:from => 'assets/css'}
    serve '/js',  {:from => 'assets/js'}
    #serve '/images', {:from => 'assets/images'}

    css :app, ['css/app.css']
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
    stations = XmlSimple.xml_in(api_response)['station']

     # unsure why their api returns  random array values...
    strongest_station = stations.max_by{|s|s['signal'][0]['strength'].to_i }

    frequency = strongest_station['frequency'][0]
    band = strongest_station['band'][0]
    call_letters = strongest_station['callLetters'][0]

    home_page = strongest_station['url'].find{ |url| url['type'] == 'Organization Home Page' }
    pledge_page =  strongest_station['url'].find{ |url| url['type'] == 'Pledge Page' }
    stream_url = strongest_station['url'].find{ |url| url['type'] =~ /MP3 Stream|AAC Stream/ && url['primary'] == 'true' }

    {
      :label => "#{frequency} #{band} - #{call_letters}",
      :home_page => home_page && home_page['content'],
      :pledge_page => pledge_page && pledge_page['content'],
      :stream_url => stream_url && stream_url['content']
    }.to_json
  end

  get '/listen' do
    # return if an actual audio file url
    unless params[:url] =~ /.pls|.m3u\b/i
      return params[:url]
    end

    playlist = open(params[:url]).read

    # support for .pls or .m3u playlists
    if params[:url] =~ /.pls\b/i
      playlist.split("\n").find{ |line| line.match /File\d/ }.split('=')[1] << ';' # trailing semi-colon to force streaming
    else
      playlist.split("\n").find{ |line| line =~ URI::regexp(['http', 'https']) }
    end
  end
end

