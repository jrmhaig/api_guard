require 'api_guard/access_token/header'
require 'action_dispatch'
require 'active_support/testing/time_helpers'

include ActiveSupport::Testing::TimeHelpers

RSpec.describe ApiGuard::AccessToken::Header do
  subject(:access_token) { described_class.new(validity: validity) }

  let(:validity) { nil }

  describe '#store' do
    subject(:store) { access_token.store(value, packet: packet) }

    let(:packet) { ActionDispatch::Response.new }
    let(:value) { 'test-value' }
    let(:current_time) { Time.new(2022, 12, 18, 18, 0, 0) }

    before { travel_to current_time }

    it { expect { store }.to change { packet.headers['Access-Token'] }.to(value) }

    context 'with an expire at time set' do
      let(:validity) { 37 * 60 }
      let(:expire_time) { current_time + validity }

      it { expect { store }.to change { packet.headers['Expire-At'] }.to(expire_time.to_i) }
    end

    context 'without an expire at time set' do
      let(:expire_time) { current_time + 5 * 60 }

      it { expect { store }.to change { packet.headers['Expire-At'] }.to(expire_time.to_i) }
    end
  end

  describe '#fetch' do
    subject { access_token.fetch(packet: packet) }

    let(:packet) { ActionDispatch::Request.new({}) }

    context 'without a value' do
      it { is_expected.to be_nil }
    end

    context 'with a value' do
      let(:value) { 'test-value' }

      before { packet.headers['Authorization'] = "Bearer #{value}" }

      it { is_expected.to eq(value) }
    end
  end
end
