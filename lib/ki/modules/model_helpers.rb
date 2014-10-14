module Ki
  class Model
    module ModelHelpers
      def get?
        @req.get?
      end

      def post?
        @req.post?
      end

      def put?
        @req.put?
      end

      def delete?
        @req.delete?
      end

      def forbidden_actions
        []
      end

      def required_attributes
        []
      end

      def skipped_params
        []
      end

      def unique_attributes
        []
      end
    end
  end
end
