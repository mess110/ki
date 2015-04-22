module Ki
  class KiApp
    def call(env)
      s = 'misplaced in space'
      Rack::Response.new(s).finish
    end
  end
end
