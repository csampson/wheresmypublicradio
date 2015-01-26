require_relative "./spec_helper"
require_relative "../../lib/playlist"

describe Playlist do
  context "given a m3u file" do
    it "should set the correct file type" do
      stub_request(:get, "http://example.com/playlist.m3u")

      playlist = Playlist.new(:url => "http://example.com/playlist.m3u")
      expect(playlist.filetype).to eq(:m3u)
    end

    describe "#get_stream_url" do
      it "should return a URI instance" do
        playlist_body = load_fixture("playlist_plain_url.m3u")

        stub_request(:get, "http://example.com/playlist.m3u").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.m3u")
        stream_url = playlist.get_stream_url

        expect(stream_url).to be_a URI
      end

      it "should extract the stream url from a playlist with a plain url" do
        playlist_body = load_fixture("playlist_plain_url.m3u")

        stub_request(:get, "http://example.com/playlist.m3u").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.m3u")
        stream_url = playlist.get_stream_url

        expect(stream_url.to_s).to eq("http://example.com/stream")
      end

      it "should extract a stream url from a playlist with a port-specified resource" do
        playlist_body = load_fixture("playlist_with_port.m3u")

        stub_request(:get, "http://example.com/playlist.m3u").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.m3u")
        stream_url = playlist.get_stream_url

        expect(stream_url.to_s).to eq("http://example.com:7200/;")
      end

      it "should extract a stream url from a playlist with a direct file reference" do
        playlist_body = load_fixture("playlist_direct.m3u")

        stub_request(:get, "http://example.com/playlist.m3u").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.m3u")
        stream_url = playlist.get_stream_url

        expect(stream_url.to_s).to eq("http://example.com/stream.mp3")
      end
    end
  end

  context "given a pls file" do
    it "should set the correct file type" do
      stub_request(:get, "http://example.com/playlist.pls")

      playlist = Playlist.new(:url => "http://example.com/playlist.pls")
      expect(playlist.filetype).to eq(:pls)
    end

    describe "#get_stream_url" do
      it "should return a URI instance" do
        playlist_body = load_fixture("playlist_plain_url.pls")

        stub_request(:get, "http://example.com/playlist.pls").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.pls")
        stream_url = playlist.get_stream_url

        expect(stream_url).to be_a URI
      end

      it "should extract the stream url from a playlist with a plain url" do
        playlist_body = load_fixture("playlist_plain_url.pls")

        stub_request(:get, "http://example.com/playlist.pls").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.pls")
        stream_url = playlist.get_stream_url

        expect(stream_url.to_s).to eq("http://example.com/stream")
      end

      it "should extract a stream url from a playlist with a port-specified resource" do
        playlist_body = load_fixture("playlist_with_port.pls")

        stub_request(:get, "http://example.com/playlist.pls").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.pls")
        stream_url = playlist.get_stream_url

        expect(stream_url.to_s).to eq("http://example.com:7200/;")
      end

      it "should extract a stream url from a playlist with a direct file reference" do
        playlist_body = load_fixture("playlist_direct.pls")

        stub_request(:get, "http://example.com/playlist.pls").to_return(:body => playlist_body)

        playlist   = Playlist.new(:url => "http://example.com/playlist.pls")
        stream_url = playlist.get_stream_url

        expect(stream_url.to_s).to eq("http://example.com/stream.mp3")
      end
    end
  end
end
