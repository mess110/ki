# frozen_string_literal: true

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
    chain = split '::'
    klass = Kernel
    chain.each do |klass_string|
      klass = klass.const_get klass_string.split('_').map(&:capitalize).join('')
    end
    klass.is_a?(Class) ? klass : nil
  rescue NameError
    nil
  end
end

class Array
  def stringify_ids
    collect do |e|
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

  def present?
    !nil? && !empty?
  end
end

class NilClass
  def present?
    false
  end
end

class Object
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a, &b)
    end
  end
end
