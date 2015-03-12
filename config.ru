require "sinatra"
require "dotenv"
require "json"

if development?
  require "sinatra/reloader"
  require "pry"
end

require "./app"
require "./lib/playlist"
require "./lib/station_finder"

Dotenv.load

App.set :run, false
run App
