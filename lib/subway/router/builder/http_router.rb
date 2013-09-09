# encoding: utf-8

module Subway
  class Router
    class Builder

      # Builds a new {Router} backed by an instance of {::HttpRouter}
      class HttpRouter < self

        def call
          routes.each { |name, route| register(name, route) }
          Router.new(routes, handler)
        end

        private

        def register(name, route)
          r = handler.add(route.path, route.options)
          r.name = name
          r.add_request_method(route.request_method.upcase)
          r.to { |env|
            dispatcher.call(name, env).output
          }
        end
      end # class HttpRouter
    end # class Builder
  end # class Router
end # module Subway
