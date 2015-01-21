require_relative "./spec_helper"
require_relative "../../lib/station_finder"

describe StationFinder do
  describe '#find_strongest_station' do
    it "should return the station with the strongest signal" do
      api_response = load_fixture("stations_api_response.xml")
      coordinates  = { :latitude => nil, :longitude => nil }

      stub_request(:get, /.*api.npr.org\/stations.*/).to_return(:body => api_response)

      strongest_station = StationFinder.find_strongest_station(coordinates)

      expect(strongest_station[:label]).to eq("89.9 FM - WWNO")
    end
  end

  it "should handle zero stations being returned from the api" do
      api_response = load_fixture("stations_api_response_empty.xml")
      coordinates  = { :latitude => nil, :longitude => nil }

      stub_request(:get, /.*api.npr.org\/stations.*/).to_return(:body => api_response)

      strongest_station = StationFinder.find_strongest_station(coordinates)

      expect(strongest_station).to be_nil
  end
end
