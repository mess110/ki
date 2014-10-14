class String
  # Converts a string to a class
  #
  # ==== Examples
  #
  #   class User
  #   end
  #
  #   "user".to_class == User
  #
  def to_class
    chain = self.split "::"
    klass = Kernel
    chain.each do |klass_string|
      klass = klass.const_get klass_string.capitalize
    end
    klass.is_a?(Class) ? klass : nil
  rescue NameError
    nil
  end
end

class Array
  def stringify_ids
    self.collect do |e|
      if e['_id']
        e['id'] = e['_id'].to_s
        e.delete('_id')
      end
      if e[:_id]
        e['id'] = e[:_id].to_s
        e.delete(:_id)
      end
      e
    end
  end
end

module Ki
  module Helpers
    include ViewHelper

    def css url
      render_haml "%link{:href => '#{url}', :rel => 'stylesheet'}"
    end

    def js url
      render_haml "%script{:src => '#{url}'}"
    end

    def render_haml s
      Haml::Engine.new(s).render
    end

    def partial s
      path = view_path(s)
      if File.file?(path)
        render_haml(File.read(path))
      else
        raise PartialNotFoundError.new path
      end
    end
  end
end
