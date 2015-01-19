if development?
  require 'sinatra/reloader'
  require 'pry'
end

require './app'
require './lib/playlist'
require './lib/station_parser'

Dotenv.load

App.set :run, false
run App
