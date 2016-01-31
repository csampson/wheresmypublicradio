require "dotenv"

if development?
  require "pry"
end

require "./app"

Dotenv.load

App.set :run, false
run App
