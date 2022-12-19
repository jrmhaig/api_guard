# frozen_string_literal: true

require 'api_guard/base_token'
require 'api_guard/mixins/cookie'

module ApiGuard
  module AccessToken
    class Cookie < ApiGuard::BaseToken
      include ApiGuard::Mixins::Cookie

      def initialize(**kwargs)
        super(**kwargs)

        @token = 'access_token'
      end
    end
  end
end
