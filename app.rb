require 'sinatra'
require 'sinatra/assetpack'
require 'open-uri'
require 'json'
require 'xmlsimple'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/css', {:from => 'assets/css'}
    serve '/js', {:from => 'assets/js'}
    serve '/images', {:from => 'assets/images'}

    css :app, ['css/app.css']
    js :app, ['js/app.js']
  }

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  get '/' do
    erb :index
  end

  get '/best_station' do
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

    "#{frequency} #{band} - #{call_letters}"
  end
end

