require_relative "./spec_helper"
require_relative "../../lib/station_finder"

xdescribe StationFinder do
  it "shoould find the station with the strongest signal" do
    api_response = load_fixture("api_response.xml")
    
    # TODO: implement spec
  end

  it "should handle zero stations being returned from the api" do
    api_response = load_fixture("api_response_no_results.xml")
    
    # TODO: implement spec
  end
end
