require_relative "./spec_helper"
require_relative "../lib/npr_request"

describe NPR do
  describe '#request' do
    it "should make a request to the given endpoint" do
      stub = stub_request(:get, /.*api.npr.org\/stations.*/)
      NPR.request(:endpoint => :search, :method => :GET)

      expect(stub).to have_been_requested
    end

    it "should append the given querystring parameters" do
      stub = stub_request(:get, /.*api.npr.org\/stations.*/).with(:query => hash_including({ :parameter => "value" }))
      NPR.request(:endpoint => :search, :method => :GET, :params => { :parameter => "value" })

      expect(stub).to have_been_requested
    end

    it "should return an array" do
      api_response = load_fixture("stations_search.json")
      stub_request(:get, /.*api.npr.org\/stations.*/).to_return(:body => api_response)

      value = NPR.request(:endpoint => :search, :method => :GET)
      expect(value).to be_an Array
    end
  end
end
