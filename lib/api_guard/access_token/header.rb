module ApiGuard
  module AccessToken
    class Header
      def initialize(validity:)
        @validity = validity || 5*60
      end

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
