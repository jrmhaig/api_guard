module ApiGuard
  module RefreshToken
    class Header
      def initialize(validity:)
        @validity = validity
      end

      def store(value, packet:)
        packet.headers['Refresh-Token'] = value
      end

      def fetch(packet:)
        packet.headers['Refresh-Token']
      end
    end
  end
end
