module Ki
  module Middleware
    module Helpers
      module HamlCompiler
        def render_haml_file(file_path)
          file_contents = File.read(file_path)

          if view_exists? 'layout'
            layout_contents = File.read(view_path('layout'))
          else
            layout_contents = '= yield'
          end

          html = render_haml(layout_contents).render do
            render_haml(file_contents).render
          end

          html
        end

        def render_haml(s)
          Haml::Engine.new("- extend Ki::Helpers\n" + s)
        end
      end
    end
  end
end
