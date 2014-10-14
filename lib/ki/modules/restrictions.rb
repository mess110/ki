module Ki
  class Model
    module Restrictions
      def forbidden_actions
        []
      end

      def forbid *actions
        send :define_method, :forbidden_actions do
          actions
        end

        eigen_class = class << self; self; end
        eigen_class.send(:define_method, :forbidden_actions) do
          actions
        end
      end

      def required_attributes
        []
      end

      def requires *attributes
        send :define_method, :required_attributes do
          attributes
        end

        eigen_class = class << self; self; end
        eigen_class.send(:define_method, :required_attributes) do
          attributes
        end
      end

      def unique_attributes
        []
      end

      def unique *attributes
        send :define_method, :unique_attributes do
          attributes
        end

        eigen_class = class << self; self; end
        eigen_class.send(:define_method, :unique_attributes) do
          attributes
        end
      end
    end
  end
end
