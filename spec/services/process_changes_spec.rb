

require "spec_helper"

RSpec.describe ProcessChanges do
  let!(:samples_path){File.join(__dir__,  'samples/').gsub("/services","")}
  let!(:db){Db.instance}

  before do
    db.refresh
  end

  it "should process a valid json file" do
    obj = load_loader("valid_mix_tape")
    chg = load_changes("valid_changes")
    expect(db.tables["playlists"].length).to eq(3)
  end

  it "should process new additions in valid json" do
    obj = load_loader("valid_mix_tape")
    chg = load_changes("valid_changes")
    expect(db.tables["playlists"]["3"].song_ids).to eq(["3","4"])
  end

  it "should process deletes in valid json" do
    obj = load_loader("valid_mix_tape")
    chg = load_changes("valid_changes")
    expect(db.tables["playlists"].has_key?("2")).to be false 
  end

  it "should process updates in valid json" do
    obj = load_loader("valid_mix_tape")
    chg = load_changes("valid_changes")
    expect(db.tables["playlists"]["4"].song_ids).to eq(["2","6","1"])
  end

  it "should load update indexes" do
    obj = load_loader("valid_mix_tape")
    chg = load_changes("out_of_order_changes")
    expect(db.indexes).to eq([1,3,8])
  end

  it "should handle json file out of order" do
    obj = load_loader("valid_mix_tape")
    chg = load_changes("out_of_order_changes")
    expect(db.tables["playlists"]["3"].song_ids).to eq(["2","4","1"])
    expect(db.tables["playlists"].has_key?("2")).to be false 
  end

  it "should ignore invalid keys and process only valid keys" do
    load_loader("valid_mix_tape")
    load_changes("invalid_changes")
    expect(db.tables["playlists"].has_key?("2")).to be false 
    expect(db.tables["playlists"]["3"].song_ids).to eq(["2","4"])
  end
  
  it "should raise InvalidAttributeError when invalid controllers in json file" do
    load_loader("valid_mix_tape")
    expect{load_changes("invalid_controller_changes")}.to raise_error(InvalidAttributeError,"users is not a supported controller")
  end

  def load_loader(filename)
    InputLoader.new("#{samples_path}#{filename}.json").call
  end

  def load_changes(filename)
    ProcessChanges.new("#{samples_path}#{filename}.json").call
  end

end
