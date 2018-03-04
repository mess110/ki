# frozen_string_literal: true

module Ki
  class BaseRequest < Rack::Request
    include Middleware::Helpers::FormatOf

    def root?
      path == '/'
    end

    def doc?
      path == '/instadoc'
    end

    def admin?
      path == '/instadmin'
    end

    def json?
      content_type == 'application/json' || format_of(path) == 'json'
    end

    def headers
      Hash[*env.select { |k, _v| k.start_with? 'HTTP_' }
               .collect { |k, v| [k.sub(/^HTTP_/, ''), v] }
               .sort
               .flatten]
    end

    def to_ki_model_class
      path.to_s.delete('/').gsub(format_of(path), '').delete('.').to_class
    end

    def to_action
      case request_method
      when 'GET'
        :find
      when 'POST'
        :create
      when 'PUT'
        :update
      when 'DELETE'
        :delete
      when 'SEARCH'
        :find
      else
        raise 'unkown action'
      end
    end
  end
end
