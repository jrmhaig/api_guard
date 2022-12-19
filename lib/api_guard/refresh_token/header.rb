# frozen_string_literal: true

require 'api_guard/base_token'

module ApiGuard
  module RefreshToken
    class Header < ApiGuard::BaseToken
      def store(value, packet:)
        packet.headers['Refresh-Token'] = value
      end

      def fetch(packet:)
        packet.headers['Refresh-Token']
      end
    end
  end
end
