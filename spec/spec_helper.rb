require "json"
require "rubygems"
require "webmock/rspec"

def load_fixture(filename)
  file = File.read(File.expand_path("../fixtures/#{filename}", __FILE__))

  if File.extname(filename) == ".json"
    JSON.parse file
  else
    file
  end
end
