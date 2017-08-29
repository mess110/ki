module Ki
  class ApiError < StandardError #:nodoc:
    extend Descendants

    attr_reader :status

    def initialize(body = nil, status = 400)
      super body.nil? ? to_s : body
      @status = status
    end

    def result
      {
        'error' => to_s,
        'status' => @status
      }
    end
  end

  class InvalidUrlError < ApiError #:nodoc:
  end

  class RequiredAttributeMissing < ApiError #:nodoc:
  end

  class AttributeNotUnique < ApiError #:nodoc:
  end

  class ForbiddenAction < ApiError #:nodoc:
    def initialize(s = 'forbidden', code = 403)
      super s, code
    end
  end

  class UnauthorizedError < ApiError #:nodoc:
    def initialize(s = 'unauthroized', code = 401)
      super s, code
    end
  end

  class PartialNotFoundError < ApiError #:nodoc:
    def initialize(s = '"partial"')
      super "partial #{s} not found", 404
    end
  end
end

class CustomError < Ki::ApiError
end
