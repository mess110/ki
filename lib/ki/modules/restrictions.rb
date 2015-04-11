module Ki
  class Model
    module Restrictions
      def forbidden_actions
        []
      end

      def forbid *actions
        generic_restriction :forbidden_actions, actions
      end

      def required_attributes
        []
      end

      def requires *attributes
        generic_restriction :required_attributes, attributes
      end

      def unique_attributes
        []
      end

      def unique *attributes
        generic_restriction :unique_attributes, attributes
      end

      private

      def generic_restriction method_name, attributes
        send :define_method, method_name do
          attributes
        end

        eigen_class = class << self; self; end
        eigen_class.send(:define_method, method_name) do
          attributes
        end
      end

    end
  end
end
