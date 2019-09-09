

require "spec_helper"

RSpec.describe Playlist do
  let!(:db){Db.instance}

  before do
    db.refresh
    load_db
  end

  it "should be able to add new playlists on empty db" do
    playlist = Playlist.new(valid_playlist_args)
    expect(playlist.song_ids).to eq(["1","3"])
    expect(playlist.validate).to be true
  end

  it "should be able to validate a new playlist" do
    playlist = Playlist.new(valid_playlist_args)
    expect(playlist.validate).to be true
  end

  it "should not validate a playlist without songs" do
    playlist = Playlist.new({"id"=> "4", "user_id" => "1", "song_ids"=>[]})
    expect(playlist.validate).to be false
  end

  it "should not validate a playlist with invalid songs" do
    playlist = Playlist.new({"id"=> "4", "user_id" => "1", "song_ids"=>["64","26"]})
    expect(playlist.validate).to be false
  end

  it "should not validate a playlist with invalid user" do
    playlist = Playlist.new({"id"=> "4", "user_id" => "16", "song_ids"=>["1","2"]})
    expect(playlist.validate).to be false
  end

  def load_db
    db.tables["playlists"] = {}
    db.tables["users"] = {"1" => User.new({"id"=>"1","name"=>"Albin Jaye"})}
    db.tables["songs"] = {"1" => Song.new({"id"=>"1","artist"=>"Jim","title"=>"Jim's Song"}),
                          "2" => Song.new({"id"=>"2","artist"=>"Joe","title"=>"Joe's Song"}),
                          "3" => Song.new({"id"=>"3","artist"=>"Jane","title"=>"Jim's Song"}),
                          "4" => Song.new({"id"=>"4","artist"=>"Jack","title"=>"Joe's Song"}),
                        }
  end

  def valid_playlist_args
    {
      "id" => "1",
      "user_id" => "1",
      "song_ids" => [
         "1",
         "3"
      ]
   }
  end

end
