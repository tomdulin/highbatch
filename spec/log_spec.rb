# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Log do
  let!(:log) { Log.instance }
  it 'can add be instantiated' do
    log.defaults(false)
    expect(log.error('test')).to be nil
  end
end
