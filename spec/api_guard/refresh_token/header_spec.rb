require 'api_guard/refresh_token/header'
require 'action_dispatch'
require 'active_support/testing/time_helpers'

include ActiveSupport::Testing::TimeHelpers

RSpec.describe ApiGuard::RefreshToken::Header do
  subject(:refresh_token) { described_class.new(validity: validity) }

  let(:validity) { nil }

  describe '#store' do
    subject(:store) { refresh_token.store(value, packet: packet) }

    let(:packet) { ActionDispatch::Response.new }
    let(:value) { 'test-value' }
    let(:current_time) { Time.new(2022, 12, 18, 18, 0, 0) }

    before { travel_to current_time }

    it { expect { store }.to change { packet.headers['Refresh-Token'] }.to(value) }
  end

  describe '#fetch' do
    subject { refresh_token.fetch(packet: packet) }

    let(:packet) { ActionDispatch::Request.new({}) }

    context 'without a value' do
      it { is_expected.to be_nil }
    end

    context 'with a value' do
      let(:value) { 'test-value' }

      before { packet.headers['Refresh-Token'] = value }

      it { is_expected.to eq(value) }
    end
  end
end
