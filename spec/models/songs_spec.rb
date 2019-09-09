require 'spec_helper'

RSpec.describe Song do
  let!(:song){Song.new({"id" => "1", "artist" => "Camila Cabello", "title" => "Never Be the Same"})}

  it 'should be able to create a new song' do
    expect(song.validate).to be true
  end

  it 'should be able to set proper artist attribute' do
    expect(song.artist).to eq('Camila Cabello')
  end
  
  it 'should be able to set proper title attribute' do
    expect(song.title).to eq('Never Be the Same')
  end

  it 'should be able to set proper id attribute' do
    expect(song.id).to eq('1')
  end
end
