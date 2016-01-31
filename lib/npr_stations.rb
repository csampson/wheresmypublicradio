require "npr_request"

module NPR
  class Stations
    def self.find(query)
      station = NPR.request(:endpoint => :search, :method => :GET, :params => query).first
      parse_station station
    end

    private
    def self.parse_station(station)
      frequency    = station["frequency"]
      band         = station["band"]
      call_letters = station['call']

      home_page    = station["urls"].find{ |url| url["type_name"] == "Organization Home Page" }
      pledge_page  = station["urls"].find{ |url| url["type_name"] == "Pledge Page" }
      stream_url   = station["urls"].find{ |url| url["primary_stream"] == 1 }

      {
        :label => "#{frequency} #{band} - #{call_letters}",
        :home_page => home_page && home_page["href"],
        :pledge_page => pledge_page && pledge_page["href"],
        :stream_url => stream_url && stream_url["href"]
      }
    end
  end
end
