# frozen_string_literal: true

module Ki
  module Middleware
    class AdminInterfaceGenerator < InstaDoc
      def custom_view_path
        File.join(File.dirname(__FILE__), '..', 'views', 'instadmin.haml')
      end

      def custom_check(req)
        req.admin?
      end
    end
  end
end
