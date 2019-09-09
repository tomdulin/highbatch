
require "spec_helper"

RSpec.describe Exporter do
  let!(:def_out_path){File.join(__dir__,  'samples', 'outfile_export.json').gsub("/services","")}
  let!(:db){Db.instance}

  before do
    File.delete(def_out_path) if File.exist?(def_out_path)
    db.refresh  
    load_db
  end

  it "should export a valid json file" do
    obj = Exporter.new(def_out_path).call
    expect(File.exist?(def_out_path)).to be true
  end

  it "should properly format the json file" do
    obj = Exporter.new(def_out_path).call
    json = JSON.parse(File.read(def_out_path))
    expect(json["users"][0]).to eq({"id"=>"1", "name"=>"Albin Jaye"})
    expect(json["songs"][0]).to eq({"id"=>"1","artist"=>"Jim","title"=>"Jim's Song"})
    expect(json["playlists"][0]).to eq({"id"=>"1","user_id"=>"1","song_ids"=>["1"]})
  end


  def load_db
    db.tables["users"] = {"1" => User.new({"id"=>"1","name"=>"Albin Jaye"})}
    db.tables["songs"] = {"1" => Song.new({"id"=>"1","artist"=>"Jim","title"=>"Jim's Song"}),
                          "2" => Song.new({"id"=>"2","artist"=>"Joe","title"=>"Joe's Song"})}
    db.tables["playlists"] = {"1"=>Playlist.new({"id"=>"1","user_id"=>"1","song_ids"=>["1"]})}
  end
end
