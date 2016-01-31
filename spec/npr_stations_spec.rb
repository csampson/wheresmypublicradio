require_relative "./spec_helper"
require_relative "../lib/npr_stations"

describe NPR::Stations do
  describe '#find' do
    it "should make a request to /stations/search/:query" do
      api_response = load_fixture("stations_search.json")
      coordinates  = { :latitude => nil, :longitude => nil }
      stub         = stub_request(:get, /.*api.npr.org\/stations.*/).to_return(:body => api_response)

      NPR::Stations.find(:query => coordinates)

      expect(stub).to have_been_requested
    end

    it "should return a station hash" do
      api_response = load_fixture("stations_search.json")
      coordinates  = { :latitude => nil, :longitude => nil }

      stub_request(:get, /.*api.npr.org\/stations.*/).to_return(:body => api_response)

      station = NPR::Stations.find(:query => coordinates)

      expect(station).to eq({
        :label => "89.9 FM - WWNO",
        :home_page => "http://www.wwno.org",
        :pledge_page => "http://wwno.org/donate",
        :stream_url => "http://www.publicbroadcasting.net/wwno/ppr/wwno_128.m3u"
      })
    end
  end
end
