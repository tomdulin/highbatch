

require "spec_helper"

RSpec.describe InputLoader do
  let!(:samples_path){File.join(__dir__,  'samples/').gsub("/services","")}
  let!(:db){Db.instance}

  before do
    db.refresh
  end

  it "should load a valid json file" do
    obj = load_loader("valid_mix_tape")
    expect(db.tables["users"]["1"].id).to eq("1")
    expect(db.tables["playlists"]["1"].song_ids).to eq(["1","2"])
    expect(db.tables["songs"]["1"].artist).to eq("Camila Cabello")
    expect(db.tables["songs"].length).to eq(8)
  end

  it "should load update indexes" do
    obj = load_loader("valid_mix_tape")
    expect(db.indexes).to eq([1,1,8])
  end

  it "should handle json file out of order" do
    obj = load_loader("out_of_order_mix_tape")
    expect(db.tables.keys).to eq(["playlists","users","songs"])
    expect(db.tables["users"]["1"].id).to eq("1")
    expect(db.tables["playlists"]["1"].song_ids).to eq(["1","2"])
    expect(db.tables["songs"]["1"].artist).to eq("Camila Cabello")
    expect(db.tables["songs"].length).to eq(8)
  end

  it "should raise InvalidAttributeError when invalid keys in json file" do
    expect{load_loader("invalid_keys_mixtape")}.to raise_error(InvalidAttributeError,"[\"playlists\"] were not found in the mixtape.json file")
  end

  def load_loader(filename)
    InputLoader.new("#{samples_path}#{filename}.json").call
  end

end
