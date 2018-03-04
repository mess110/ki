# frozen_string_literal: true

module Ki
  module Middleware
    module Helpers
      module HamlCompiler
        def render_haml_file(file_path, layout = true)
          file_contents = File.read(file_path)

          layout_contents = if layout && view_exists?('layout')
                              File.read(view_path('layout'))
                            else
                              '= yield'
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
