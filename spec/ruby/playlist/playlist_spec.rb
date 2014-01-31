require_relative '../../../playlist'

describe Playlist do
  context 'given a m3u file' do
    it 'can instantiate with options' do
      playlist = Playlist.new(:body => '#test', :filetype => :m3u)

      expect(playlist.body).to eq('#test')
      expect(playlist.filetype).to eq(:m3u)
    end

    it 'can extract a stream url from a playlist with a plain url' do
      file_contents = File.read(File.expand_path('../playlist_plain_url.m3u', __FILE__))
      playlist = Playlist.new(:body => file_contents, :filetype => :m3u)

      expect(playlist.get_stream_url).to eq('http://example.com/stream')
    end

    it 'can extract a stream url from a playlist with a port-specified resource' do
      file_contents = File.read(File.expand_path('../playlist_with_port.m3u', __FILE__))
      playlist = Playlist.new(:body => file_contents, :filetype => :m3u)

      expect(playlist.get_stream_url).to eq('http://example.com:7200/;')
    end

    it 'can extract a stream url from a playlist with a direct file reference' do
      file_contents = File.read(File.expand_path('../playlist_direct.m3u', __FILE__))
      playlist = Playlist.new(:body => file_contents, :filetype => :m3u)

      expect(playlist.get_stream_url).to eq('http://example.com/stream.mp3')
    end
  end

  context 'given a pls file' do
    it 'can instantiate with options' do
       playlist = Playlist.new(:body => '[playlist]', :filetype => :pls)

      expect(playlist.body).to eq('[playlist]')
      expect(playlist.filetype).to eq(:pls)
    end

    it 'can extract a stream url from a playlist with a plain url' do
      file_contents = File.read(File.expand_path('../playlist_plain_url.pls', __FILE__))
      playlist = Playlist.new(:body => file_contents, :filetype => :pls)

      expect(playlist.get_stream_url).to eq('http://example.com/stream')
    end

    it 'can extract a stream url from a playlist with a port-specified resource' do
      file_contents = File.read(File.expand_path('../playlist_with_port.pls', __FILE__))
      playlist = Playlist.new(:body => file_contents, :filetype => :pls)

      expect(playlist.get_stream_url).to eq('http://example.com:7200/;')
    end

    it 'can extract a stream url from a playlist with a direct file reference' do
      file_contents = File.read(File.expand_path('../playlist_direct.pls', __FILE__))
      playlist = Playlist.new(:body => file_contents, :filetype => :pls)

      expect(playlist.get_stream_url).to eq('http://example.com/stream.mp3')
    end
  end
end
