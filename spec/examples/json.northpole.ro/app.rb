require 'ki'

NP_API_KEY = 'api_key'
NP_SECRET = 'secret'
NP_GUEST_API_KEY = 'guest'
NP_GUEST_SECRET = 'guest'
NP_URL = 'http://json.northpole.ro'

def get_time
  Time.now.to_i
end

module Ki
  module Helpers
    def other_developer_count
      user_count = haml("%span.badge #{User.count}")
      storage_count = haml("%span.badge #{Storage.count}")
      "#{user_count} developers with #{storage_count} resources"
    end
  end

  class Model
    def before_all
      # ensure_authorization
    end

    private

    def ensure_authorization
      if params[NP_API_KEY].nil?
        raise UnauthorizedError.new("not authorized. #{NP_API_KEY} is missing")
      end
      if params[NP_SECRET].nil?
        raise UnauthorizedError.new("not authorized. #{NP_SECRET} is missing")
      end

      h = { NP_API_KEY => params[NP_API_KEY], NP_SECRET => params[NP_SECRET]}
      u = User.find(h)
      unless action == :create && self.class == User
        if u.empty?
          raise UnauthorizedError.new
        end
      end
      params.delete(NP_SECRET) if !required_attributes.include? NP_SECRET.to_sym
    end
  end
end

class User < Ki::Model
  requires NP_API_KEY.to_sym, NP_SECRET.to_sym
  forbid :delete, :update
  unique NP_API_KEY.to_sym

  def before_create
    raise Ki::ApiError.new('invalid api key. /(\W)/ only', 400) unless valid_api_key?(params[NP_API_KEY])
    params['created_at'] = get_time
  end

  private

  def valid_api_key? s
    s.gsub(/(\W|\d)/, "") == s
  end
end

class Redirector < Ki::Model
  def after_find
    @result = @req.headers
    # @params['redirect_to'] = 'http://localhost:1337/'
  end
end

class Storage < Ki::Model
  requires NP_API_KEY.to_sym

  def before_create
    params['created_at'] = get_time
  end

  def before_update
    raise Ki::ApiError.new('id param required', 400) unless params['id']
    storage = Storage.find(params['id'])
    raise Ki::ApiError.new('json object not found', 404) if storage.empty?
    params['created_at'] = storage.first['created_at']
  end
end
