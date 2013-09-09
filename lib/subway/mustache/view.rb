# encoding: utf-8

module Subway
  module Mustache

    # Base class for mustache views with layout support
    class View < ::Mustache

      include Concord::Public.new(:data)

      DEFAULTS = ->(base) do
        ->(_) do
          self.view_namespace = base.view_namespace
          self.template_path  = base.template_path

          layout_view(superclass)
        end
      end

      def self.layout_view(view = Undefined)
        return @layout_view if view.equal?(Undefined)
        @layout_view = view
      end

      def layout_view(view = Undefined)
        self.class.layout_view(view)
      end

      def layout_template
        layout_view.template
      end

    end
  end
end
