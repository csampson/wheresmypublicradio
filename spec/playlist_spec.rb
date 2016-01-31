require_relative "./spec_helper"
require_relative "../lib/playlist"

PLAYLIST_URLS = {
  :m3u => "http://example.com/playlist.m3u",
  :pls => "http://example.com/playlist.pls"
}

PLAYLIST_CONTENT = {
  :m3u_plain     => load_fixture("playlist_plain_url.m3u"),
  :m3u_with_port => load_fixture("playlist_with_port.m3u"),
  :m3u_with_file => load_fixture("playlist_with_file.m3u"),
  :pls_plain     => load_fixture("playlist_plain_url.pls"),
  :pls_with_port => load_fixture("playlist_with_port.pls"),
  :pls_with_file => load_fixture("playlist_with_file.pls")
}

PLAYLISTS = {
  :m3u_plain => {
    :body => PLAYLIST_CONTENT[:m3u_plain],
    :url  => PLAYLIST_URLS[:m3u]
  },
  :m3u_with_port => {
    :body => PLAYLIST_CONTENT[:m3u_with_port],
    :url  => PLAYLIST_URLS[:m3u]
  },
  :m3u_with_file => {
    :body => PLAYLIST_CONTENT[:m3u_with_file],
    :url  => PLAYLIST_URLS[:m3u]
  },
  :pls_plain => {
    :body => PLAYLIST_CONTENT[:pls_plain],
    :url  => PLAYLIST_URLS[:pls]
  },
  :pls_with_port => {
    :body => PLAYLIST_CONTENT[:pls_with_port],
    :url  => PLAYLIST_URLS[:pls]
  },
  :pls_with_file => {
    :body => PLAYLIST_CONTENT[:pls_with_file],
    :url  => PLAYLIST_URLS[:pls]
  }
}

def use_playlist(id)
  playlist = PLAYLISTS[id]
  WebMock.stub_request(:get, playlist[:url]).to_return(:body => playlist[:body])
end

def get_stream_url(id)
  Playlist.get_stream_url(:url => PLAYLISTS[id][:url])
end

describe Playlist do
  describe "#get_stream_url" do
    context "given a m3u file" do
      it "should return a URI instance" do
        use_playlist :m3u_plain
        stream_url = get_stream_url :m3u_plain

        expect(stream_url).to be_a URI
      end

      context "given a plain url" do
        it "should extract the stream url" do
          use_playlist :m3u_plain
          stream_url = get_stream_url :m3u_plain

          expect(stream_url.to_s).to eq("http://example.com/stream")
        end
      end

      context "given a url with a port specified" do
        it "should extract the stream url" do
          use_playlist :m3u_with_port
          stream_url = get_stream_url :m3u_with_port

          expect(stream_url.to_s).to eq("http://example.com:7200/;")
        end
      end

      context "given a url with a direct file reference in the response" do
        it "should extract the stream url" do
          use_playlist :m3u_with_file
          stream_url = get_stream_url :m3u_with_file

          expect(stream_url.to_s).to eq("http://example.com/stream.mp3")
        end
      end
    end

    context "given a pls file" do
      it "should return a URI instance" do
        use_playlist :pls_plain
        stream_url = get_stream_url :pls_plain

        expect(stream_url).to be_a URI
      end

      context "given a plain url" do
        it "should extract the stream url" do
          use_playlist :pls_plain
          stream_url = get_stream_url :pls_plain

          expect(stream_url.to_s).to eq("http://example.com/stream")
        end
      end

      context "given a url with a port specified" do
        it "should extract the stream url" do
          use_playlist :pls_with_port
          stream_url = get_stream_url :pls_with_port

          expect(stream_url.to_s).to eq("http://example.com:7200/;")
        end
      end

      context "given a url with a direct file reference in the response" do
        it "should extract the stream url" do
          use_playlist :pls_with_file
          stream_url = get_stream_url :pls_with_file

          expect(stream_url.to_s).to eq("http://example.com/stream.mp3")
        end
      end
    end
  end
end
