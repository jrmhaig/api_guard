# frozen_string_literal: true

require 'api_guard/base_token'
require 'api_guard/mixins/cookie'

module ApiGuard
  module RefreshToken
    class Cookie < ApiGuard::BaseToken
      include ApiGuard::Mixins::Cookie

      def initialize(**kwargs)
        super(**kwargs)

        @token = 'refresh_token'
      end
    end
  end
end
