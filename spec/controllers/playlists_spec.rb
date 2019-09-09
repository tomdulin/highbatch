

require "spec_helper"

RSpec.describe Playlists do
  let!(:playlists){Playlists.new}
  let!(:db){Db.instance}

  before do
    db.refresh
    load_db
  end

  it "should have supported actions" do
    expect(playlists.allowed_actions).to eq(%w[new update delete])
  end

  it "should be able to add new playlists on empty db" do
    playlists.new(valid_playlist_args)
    expect(db.tables["playlists"]["1"].song_ids).to eq(["1","3"])
  end

  it "should not add a playlist without any songs" do
    playlists.new({"user_id" => "1", "song_ids"=>[]})
    expect(db.tables["playlists"].has_key?("1")).to be false
  end

  it "should raise InvalidAttributeError when attributes are missing" do
    expect{playlists.new({"user_id" => "1"})}.to raise_error(InvalidAttributeError,"[\"song_ids\"] were not found in the attributes of playlist")
  end

  it "should be able to add a song" do
    playlists.new(valid_playlist_args)
    playlists.update({"id" => "1", "song_ids"=>["2"]})
    expect(db.tables["playlists"]["1"].song_ids).to eq(["1","3","2"])
  end

  it "should be able to delete a playlist" do
    playlists.new(valid_playlist_args)
    playlists.delete({"id" => "1"})
    expect(db.tables["playlists"].has_key?("1")).to be false
  end

  it "should be able to delete a playlist and add another playlist" do
    playlists.new(valid_playlist_args)
    playlists.delete({"id" => "1"})
    expect(db.tables["playlists"].has_key?("1")).to be false
    playlists.new(valid_playlist_args)
    expect(db.tables["playlists"].has_key?("1")).to be false
    expect(db.tables["playlists"].has_key?("2")).to be true
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
      "user_id" => "1",
      "song_ids" => [
         "1",
         "3"
      ]
   }
  end

end
