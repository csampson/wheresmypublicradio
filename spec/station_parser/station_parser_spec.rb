require_relative '../../station_parser'

describe StationParser do
  api_response = File.read('api_response.xml')

  it 'can initialize with an xml api response' do
    station_parser = StationParser.new(:stations_xml => api_response)

    expect(station_parser.stations).to be_an_instance_of(Array)
  end

  it 'can find the station with the strongest signal' do
    station_parser = StationParser.new(:stations_xml => api_response)
    strongest_station = station_parser.get_strongest_station

    expect(strongest_station[:signal_strength]).to eq(5)
  end
end
