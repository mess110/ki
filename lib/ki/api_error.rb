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
    def initialize
      super 'action forbidden', 400
    end
  end
  class PartialNotFoundError < ApiError
    def initialize s
      super "partial #{s} not found", 404
    end
  end
end
