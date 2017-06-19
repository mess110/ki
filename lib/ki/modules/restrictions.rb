module Ki
  class Model
    module Restrictions
      def forbidden_actions
        []
      end

      def forbid(*actions)
        generic_restriction :forbidden_actions, actions
      end

      def required_attributes
        []
      end

      def requires(*attributes)
        generic_restriction :required_attributes, attributes
      end

      def unique_attributes
        []
      end

      def unique(*attributes)
        generic_restriction :unique_attributes, attributes
      end

      private

      def generic_restriction(method_name, attributes)
        [:define_method, :define_singleton_method].each do |definition_means|
          send definition_means, method_name do
            attributes
          end
        end
      end
    end
  end
end
