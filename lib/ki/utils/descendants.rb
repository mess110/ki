# frozen_string_literal: true

module Ki
  module Descendants
    def descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
