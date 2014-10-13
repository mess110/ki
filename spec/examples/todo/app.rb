require 'ki'

module Ki::Helpers
  def say_hello
    'hello'
  end
end

class Todo < Ki::Model
  requires :title
end
