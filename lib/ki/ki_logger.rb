# frozen_string_literal: true

require 'singleton'

module Ki
  class KiLogger
    include Singleton

    attr_accessor :logger

    def init(logger)
      @logger = logger
    end
  end
end
