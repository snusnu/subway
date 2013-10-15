# encoding: utf-8

module Subway

  # Encapsulates a rack router
  class Router

    include Concord.new(:routes, :handler)
    include Adamantium::Flat

    def call(env)
      handler.call(env)
    end

    def url(name, *args)
      handler.url(name, *args)
    end

    def path(name, *args)
      handler.path(name, *args)
    end
  end # class Router
end # module Subway
