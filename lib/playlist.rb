require "open-uri"

class Playlist
  attr_accessor :body, :filetype

  def initialize(options)
    @body     = open(options[:url]).read
    @filetype = options[:url] =~ /.pls\b/i ? :pls : :m3u
  end

  def get_stream_url
    if @filetype == :m3u
      stream_url = extract_url_from_m3u
    elsif @filetype == :pls
      stream_url = extract_url_from_pls
    end

    # append trailing slash + semi-colon to force streaming from shoutcast/icecast/etc
    if stream_url =~ /:\d/
      stream_url << "/" unless stream_url =~ /\/$/ # add a trailing slash unless one already exists
      stream_url << ";"
    end

    URI stream_url
  end

  private
  def extract_url_from_m3u
    split_body           = @body.strip.split("\n")
    stream_comment_index = split_body.find_index{|line| line =~ /^#.*stream/i } # attempt to find a comment indicating a stream url is next

    if stream_comment_index
      split_body[stream_comment_index + 1] # use stream labeled by comment
    else
      split_body.find{ |line| line =~ URI::regexp(["http", "https"]) } # otherwise just find the first url
    end
  end

  def extract_url_from_pls
    @body.strip.split("\n").find{ |line| line.match /File\d/ }.split('=')[1] # grab the first resource referenced
  end
end
