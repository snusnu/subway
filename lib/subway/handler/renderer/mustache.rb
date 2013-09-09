# encoding: utf-8

module Subway
  module Handler
    class Renderer

      # Renderer for mustache views and templates with layout support
      class Mustache < self

        def call
          rendered = view.render(view.template, view.data)

          if view.class < view.layout_view
            rendered = view.render(view.layout_template, :yield => rendered)
          end

          rendered
        end

      end # class Mustache
    end # class Renderer
  end # module Handler
end # module Subway
