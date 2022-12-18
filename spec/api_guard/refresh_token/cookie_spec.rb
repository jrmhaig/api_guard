require 'api_guard/refresh_token/cookie'
require 'action_dispatch'
require 'active_support/testing/time_helpers'

include ActiveSupport::Testing::TimeHelpers

RSpec.describe ApiGuard::RefreshToken::Cookie do
  subject(:refresh_token) { described_class.new(validity: validity) }

  let(:validity) { nil }

  describe '#store' do
    subject(:store) { refresh_token.store(value, packet: packet) }

    let(:packet) { ActionDispatch::Response.new }
    let(:value) { 'test-value' }
    let(:current_time) { Time.new(2022, 12, 18, 18, 0, 0) }

    before { travel_to current_time }

    it { expect { store }.to change { packet.cookies['refresh_token'] }.to(value) }

    context 'with an expire at time set' do
      let(:validity) { 37 * 60 }
      let(:expire_time) { current_time + validity }

      it { expect { store }.to change { packet.headers['Set-Cookie']}.to match(/refresh_token.*expires=#{expire_time.strftime('%a, %d %b %Y')}.*HttpOnly/) }
    end

    context 'without an expire at time set' do
      let(:expire_time) { current_time + 5 * 60 }

      it { expect { store }.to change { packet.headers['Set-Cookie']}.to match(/refresh_token.*expires=#{expire_time.strftime('%a, %d %b %Y')}.*HttpOnly/) }
    end
  end

  describe '#fetch' do
    subject { refresh_token.fetch(packet: packet) }

    let(:packet) { ActionDispatch::Request.new({}) }

    context 'without a value' do
      it { is_expected.to be_nil }
    end

    context 'with a value' do
      let(:value) { 'test-value' }

      before { packet.cookies['refresh_token'] = value }

      it { is_expected.to eq(value) }
    end
  end
end
