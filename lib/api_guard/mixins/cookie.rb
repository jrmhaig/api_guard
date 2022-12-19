# frozen_string_literal: true

module ApiGuard
  module Mixins
    module Cookie
      def store(value, packet:)
        packet.set_cookie(
          @token,
          {
            value: value,
            http_only: true,
            expires: Time.now + @validity,
            path: '/'
          }
        )
      end

      def fetch(packet:)
        packet.cookies[@token]
      end
    end
  end
end
