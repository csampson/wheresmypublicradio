require "sinatra/base"
require "sinatra/reloader"
require "./lib/npr_station_finder"

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    erb :index
  end

  get "/stations" do
    location = params[:location]
    stations = NPR::Stationfinder.find(:query => location)

    json stations
  end
end
