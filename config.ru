require 'dotenv'
require './app'

Dotenv.load
App.set :run, false
run App

