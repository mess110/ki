module Ki
  class BaseRequest < Rack::Request
    include Middleware::Helpers::FormatOf

    def root?
      path == '/'
    end

    def json?
      content_type == 'application/json' || format_of(path) == 'json'
    end

    def to_ki_model_class
      self.path.to_s.gsub('/','').gsub(format_of(path), '').gsub('.', '').to_class
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
