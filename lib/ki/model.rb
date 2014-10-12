module Ki
  class Model
    extend QueryInterface
    extend Restrictions
    include Callbacks
    include ModelHelpers

    attr_accessor :action, :result, :params, :status

    def initialize action, params
      @action = action
      @params = params
      @status = 200

      raise ForbiddenAction.new if forbidden_actions.include? @action
      ccall
    end

    def find
      @result = self.class.find @params
    end

    def create
      check_for_required_attributes
      check_for_unique_attributes
      @result = self.class.create @params
    end

    def update
      check_for_required_attributes
      check_for_unique_attributes
      @result = self.class.update @params
    end

    def delete
      @result = self.class.delete @params
    end

    private

    def check_for_required_attributes
      required_attributes.each do |ra|
        if !@params.keys.include?(ra.to_s)
          raise RequiredAttributeMissing.new("#{ra.to_s} missing")
        end
      end
    end

    def check_for_unique_attributes
      unique_attributes.each do |ua|
        u = self.class.find({ua.to_s => @params[ua.to_s]})
        unless u.empty?
          raise AttributeNotUnique.new("#{ua.to_s} not unique")
        end
      end
    end

    def ccall
      before_all
      send "before_#{@action.to_s}".to_sym
      send @action.to_sym
      send "after_#{@action.to_s}".to_sym
      after_all
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
