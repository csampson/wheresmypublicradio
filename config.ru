require "sinatra"
require "sinatra/assetpack"
require "dotenv"
require "json"
require "sass"
require "yui/compressor"

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
