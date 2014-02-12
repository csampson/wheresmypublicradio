require 'open-uri'
require 'json'
require 'dotenv'
require 'sinatra'
require 'sinatra/assetpack'

if ENV['RACK_ENV'] == 'development'
  require 'pry'
end

require './app'
require './lib/playlist'
require './lib/station_parser'

Dotenv.load

App.set :run, false
run App
