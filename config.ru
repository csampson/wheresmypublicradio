require 'open-uri'
require 'json'
require 'dotenv'
require 'sinatra'
require 'sinatra/assetpack'
require 'sass'

if ENV['RACK_ENV'] == 'development'
  require 'pry'
end

require './app'
require './lib/playlist'
require './lib/station_parser'

Dotenv.load

App.set :run, false
run App
