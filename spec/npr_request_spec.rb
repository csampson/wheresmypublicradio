require_relative "./spec_helper"
require_relative "../lib/npr_request"

describe NPR do
  describe '#request' do
    it "should make a request to the given endpoint" do
      stub = stub_request(:get, /.*api.npr.org\/v2\/stations.*/)
      NPR.request(:endpoint => :search, :method => :GET)

      expect(stub).to have_been_requested
    end

    it "should append the given querystring parameters" do
      stub = stub_request(:get, /.*api.npr.org\/v2\/stations.*/).with(:query => hash_including({ :parameter => "value" }))
      NPR.request(:endpoint => :search, :method => :GET, :params => { :parameter => "value" })

      expect(stub).to have_been_requested
    end

    it "should return a string of the response body" do
      api_response = load_fixture("stations_search.json")
      stub_request(:get, /.*api.npr.org\/v2\/stations.*/).to_return(:body => api_response)

      value = NPR.request(:endpoint => :search, :method => :GET)
      expect(value).to eq(api_response)
    end
  end
end
