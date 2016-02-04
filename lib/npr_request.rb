require "net/http"

module NPR
  API_KEY   = ENV["NPR_API_KEY"]
  BASE_URL  = "https://api.npr.org/v2"
  METHODS   = {
    :GET => 'get'
  }
  ENDPOINTS = {
    :search => "/stations/search"
  }

  def self.request(options)
    endpoint = ENDPOINTS[options[:endpoint]]
    method   = METHODS[options[:method]]
    uri      = URI(BASE_URL + endpoint)
    query    = { :apiKey => API_KEY }

    if (options[:method] == :GET && !options[:params].nil?)
      query.merge! options[:params]
    end

    uri.query = URI.encode_www_form(query)

    Net::HTTP.method(method).call(uri)
  end
end
