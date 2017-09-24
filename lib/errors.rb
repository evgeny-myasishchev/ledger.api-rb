# frozen_string_literal: true

module Errors
  class HttpError < StandardError
    attr_reader :status, :errors
    def initialize(title, errors: [default_error], status: nil)
      super(title)
      @status = status || errors[0][:status]
      @errors = errors
    end

    def self.default_error
      { status: 500, code: 'Internal Server Error', detail: nil, source: nil, meta: nil }
    end
  end

  class UnauthorizedRequestError < HttpError
    def initialize(title)
      super(title, errors: [{
        status: 401, title: title, code: 'Unauthorized'
      }])
    end
  end

  class ForbiddenRequestError < HttpError
    def initialize(title)
      super(title, errors: [{
        status: 403, title: title, code: 'Forbidden'
      }])
    end
  end
end
