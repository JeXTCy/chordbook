require "test_helper"

class TrackTest < ActiveSupport::TestCase
  test "exposes media" do
    track = build :track, metadata: {"strMusicVid" => "http://www.youtube.com/watch?v=T0l_6Zw1828"}
    assert_equal "http://www.youtube.com/watch?v=T0l_6Zw1828", track.media
  end

  test "lookup returns track with more listeners" do
    track = create :track, listeners: 10
    create :track, title: track.title, artist: track.artist, listeners: 2
    create :track, title: track.title, artist: track.artist, listeners: nil # unknown

    assert_equal track, Track.lookup(track.title)
  end

  test "gets genre from metadata" do
    assert_equal "R&B", create(:track, metadata: {strGenre: "R&B"}).genre.name
  end

  test "falls back to album genre" do
    album = create(:album, genre: create(:genre))
    track = create(:track, album: album)

    assert_equal album.genre, track.genre
  end
end
