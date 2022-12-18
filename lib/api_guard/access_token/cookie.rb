module ApiGuard
  module AccessToken
    class Cookie
      def initialize(validity:)
        @validity = validity || 5*60
      end

      def store(value, packet:)
        packet.set_cookie(
          'access_token',
          {
            value: value,
            http_only: true,
            expires: Time.now + @validity,
            path: '/'
          }
        )
      end

      def fetch(packet:)
        packet.cookies['access_token']
      end
    end
  end
end
