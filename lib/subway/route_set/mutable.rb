# encoding: utf-8

module Subway
  class RouteSet

    # A mutable {RouteSet} used for collecting route data
    class Mutable < self

      def initialize(routes = {})
        super
      end

      def router(handler, dispatcher)
        Router::Builder.call(handler, RouteSet.new(routes.dup), dispatcher)
      end

      def add(name, config)
        coerced_name = name.to_sym
        routes[coerced_name] = Route.new(coerced_name, config)
      end
    end # class Mutable
  end # class RouteSet
end # module Subway
