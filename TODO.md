# deploy new version to rubygems
# add logging
# respect RESTful routing /foo/:id is the only thing missing

if param is set to redirect_to, ki will redirect

class Redirector < Ki::Model
  def after_find
    @params['redirect_to'] = 'http://localhost:1337/'
  end
end>

how to read headers

class Headers < Ki::Model
  def after_find
    @result = @req.headers
  end
end
