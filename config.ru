require 'open-uri'
require 'net/http'
require 'json'
require 'dotenv'
require 'sinatra'
require 'sinatra/assetpack'
require 'sass'

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
