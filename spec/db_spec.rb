# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Db do
  let!(:db) { Db.instance }

  before do
    db.refresh
  end


  it 'defaults instantiated' do
    expect(db.indexes).to eq([0, 0, 0])
    expect(db.tables).to eq({})
  end

  it 'gets user index' do
    expect(db.get_users_index).to eq(1)
    expect(db.indexes[0]).to eql(1)
  end
  it 'gets playlists index' do
    expect(db.get_playlists_index).to eq(1)
    expect(db.indexes[1]).to eql(1)
  end
  it 'gets songs index' do
    expect(db.get_songs_index).to eq(1)
    expect(db.indexes[2]).to eql(1)
  end
end
