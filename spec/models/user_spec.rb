require 'spec_helper'

RSpec.describe User do
  let!(:user){User.new("id" => '1', "name" => 'Albin Jaye')}
  it 'should be able to create a new user' do
    expect(user.validate).to be true
  end

  it 'should be able to set proper name attribute' do
    expect(user.name).to eq('Albin Jaye')
  end

  it 'should be able to set proper id attribute' do
    expect(user.id).to eq('1')
  end
end
