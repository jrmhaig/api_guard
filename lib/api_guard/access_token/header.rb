# frozen_string_literal: true

require 'api_guard/base_token'

module ApiGuard
  module AccessToken
    class Header < ApiGuard::BaseToken
      def store(value, packet:)
        packet.headers['Access-Token'] = value
        packet.headers['Expire-At'] = (Time.now + @validity).to_i
      end

      def fetch(packet:)
        match = packet.headers['Authorization']&.match(/^Bearer (.*)$/)
        match ? match[1] : nil
      end
    end
  end
end
