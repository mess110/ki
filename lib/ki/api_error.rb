module Ki
  class ApiError < StandardError #:nodoc:
    attr_reader :status

    def initialize body, status=400
      super body
      @status = status
    end

    def result
      { 'error' => to_s }
    end
  end

  class InvalidUrlError < ApiError #:nodoc:
  end

  class RequiredAttributeMissing < ApiError #:nodoc:
  end

  class AttributeNotUnique < ApiError #:nodoc:
  end

  class ForbiddenAction < ApiError #:nodoc:
    def initialize s='forbidden', code=403
      super s, code
    end
  end

  class UnauthorizedError < ApiError #:nodoc:
    def initialize s='unauthroized', code=401
      super s, code
    end
  end

  class PartialNotFoundError < ApiError #:nodoc:
    def initialize s
      super "partial #{s} not found", 404
    end
  end
end
