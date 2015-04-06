require "net/http"
require "xmlsimple"

class StationFinder
  def self.find_strongest_station(coordinates)
    api_params = ::URI.encode_www_form({
      :apiKey => ENV["API_KEY"], # TODO: remove ENV dependency
      :lon => coordinates[:longitude],
      :lat => coordinates[:latitude]
    })

    api_response      = Net::HTTP.get(URI("https://api.npr.org/stations?#{api_params}")) # TODO: abstract API requests out
    stations          = XmlSimple.xml_in(api_response)["station"].reject(&:empty?)
    strongest_station = stations.max_by{ |s|s["signal"][0]["strength"].to_i }

    unless strongest_station.nil?
      parse_station strongest_station
    end
  end

  private
  def self.parse_station(station)
    frequency    = station["frequency"][0]
    band         = station["band"][0]
    call_letters = station['callLetters'][0]

    home_page       = station["url"].find{ |url| url["type"] == "Organization Home Page" }
    pledge_page     = station["url"].find{ |url| url["type"] == "Pledge Page" }
    stream_url      = station["url"].find{ |url| url["type"] =~ /MP3 Stream/ && url["primary"] == "true" }
    signal_strength = station["signal"][0]["strength"].to_i

    {
      :label => "#{frequency} #{band} - #{call_letters}",
      :home_page => home_page && home_page["content"],
      :pledge_page => pledge_page && pledge_page["content"],
      :stream_url => stream_url && stream_url["content"],
      :signal_strength => signal_strength
    }
  end
end
