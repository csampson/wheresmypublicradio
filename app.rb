class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

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
