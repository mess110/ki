# frozen_string_literal: true

module Ki
  class Model
    extend Descendants
    extend QueryInterface
    extend Restrictions
    include Callbacks
    include ModelHelper
    include Middleware::Helpers::RedirectTo

    annotate!

    attr_accessor :action, :result, :params, :status, :req

    def initialize(req)
      @req = req
      @action = req.to_action
      @params = req.params
      @status = 200

      raise ForbiddenAction if forbidden_actions.include? @action

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
        unless @params.keys.include?(ra.to_s)
          raise RequiredAttributeMissing, "#{ra} missing"
        end
      end
    end

    def check_for_unique_attributes
      unique_attributes.each do |ua|
        u = self.class.find({ ua.to_s => @params[ua.to_s] })
        raise AttributeNotUnique, "#{ua} not unique" unless u.empty?
      end
    end

    def ccall
      before_all
      send "before_#{@action}".to_sym
      send @action.to_sym
      send "after_#{@action}".to_sym
      after_all
    end
  end
end
