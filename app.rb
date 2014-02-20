class App < Sinatra::Base
  register Sinatra::AssetPack

  configure :development do
    register Sinatra::Reloader
  end

  assets {
    serve '/css', {:from => 'assets/css'}
    serve '/js',  {:from => 'assets/js'}
    #serve '/images', {:from => 'assets/images'}

    css :app, ['css/app.css']
    js  :app, ['js/app.js', 'js/controllers.js', 'js/services.js', 'js/directives.js']

    css_compression :yui
    js_compression  :uglify
  }

  set :scss, { :load_paths => [ "#{App.root}/assets/css" ] }

  get '/' do
    erb :index
  end

  get '/best_station' do
    content_type :json

    api_params = {:apiKey => ENV['API_KEY']}
    api_params[:lon] = params['longitude']
    api_params[:lat] = params['latitude']

    api_params_encoded = ::URI.encode_www_form(api_params)
    api_response = open("http://api.npr.org/stations?#{api_params_encoded}").read
    station_parser = StationParser.new(:stations_xml => api_response)

    station_parser.get_strongest_station.to_json unless station_parser.stations.empty?
  end

  get '/listen' do
    # return if an actual audio file url
    unless params[:url] =~ /.pls|.m3u*\b/i
      return params[:url]
    end

    playlist_body = open(params[:url]).read
    playlist = Playlist.new( :body => playlist_body, :filetype => params[:url] =~ /.pls\b/i ? :pls : :m3u )

    playlist_url = playlist.get_stream_url

    endpoint_uri = URI(playlist_url)
    endpoint_http = Net::HTTP.start(endpoint_uri.host, endpoint_uri.port)
    endpoint_response = nil

    # Verify source supports appending /; for forced streaming
    endpoint_http.request_get('/;') { |response| endpoint_response = response; next }

    if endpoint_response.is_a?(Net::HTTPSuccess)
      playlist_url
    else
      playlist_url.gsub(/\/;$/, '')
    end
  end
end
