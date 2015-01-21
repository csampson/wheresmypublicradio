require "rubygems"
require "webmock/rspec"

def load_fixture(filename)
  File.read(File.expand_path("../fixtures/#{filename}", __FILE__))
end
