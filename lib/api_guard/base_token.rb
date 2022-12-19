# frozen_string_literal: true

module ApiGuard
  class BaseToken
    def initialize(validity:)
      @validity = validity || 5 * 60
    end
  end
end
