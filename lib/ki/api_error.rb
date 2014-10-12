module Ki
  class ApiError < StandardError
    attr_reader :status

    def initialize body, status=400
      super body
      @status = status
    end

    def result
      { 'error' => to_s }
    end
  end

  class InvalidUrlError < ApiError; end
  class RequiredAttributeMissing < ApiError; end
  class AttributeNotUnique < ApiError; end
  class ForbiddenAction < ApiError
    def initialize s='forbidden', code=403
      super s, code
    end
  end
  class UnauthorizedError < ApiError
    def initialize s='unauthroized', code=401
      super s, code
    end
  end
  class PartialNotFoundError < ApiError
    def initialize s
      super "partial #{s} not found", 404
    end
  end
end
