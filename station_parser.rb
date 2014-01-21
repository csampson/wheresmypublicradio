require 'xmlsimple'

class StationParser
  attr_accessor :stations

  def initialize(options)
    @stations = XmlSimple.xml_in(options[:stations_xml])['station']
  end

  def get_strongest_station
    parse_station @stations.max_by{|s|s['signal'][0]['strength'].to_i }
  end

  private
  def parse_station(station)
    frequency = station['frequency'][0]
    band = station['band'][0]
    call_letters = station['callLetters'][0]

    home_page = station['url'].find{ |url| url['type'] == 'Organization Home Page' }
    pledge_page = station['url'].find{ |url| url['type'] == 'Pledge Page' }
    stream_url = station['url'].find{ |url| url['type'] =~ /MP3 Stream/ && url['primary'] == 'true' }
    signal_strength = station['signal'][0]['strength'].to_i

    {
      :label => "#{frequency} #{band} - #{call_letters}",
      :home_page => home_page && home_page['content'],
      :pledge_page => pledge_page && pledge_page['content'],
      :stream_url => stream_url && stream_url['content'],
      :signal_strength => signal_strength
    }
  end
end
