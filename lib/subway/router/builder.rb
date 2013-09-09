# encoding: utf-8

module Subway
  class Router

    # Abstract base class for building {Router} instances
    #
    # @abstract
    class Builder

      include AbstractType
      include Concord.new(:handler, :routes, :dispatcher)
      include Adamantium::Flat

      def self.call(handler, routes, dispatcher)
        case handler
        when ::HttpRouter
          HttpRouter.new(handler, routes, dispatcher).call
        else
          raise ArgumentError, "#{handler.class} is not supported"
        end
      end

      abstract_method :call

    end # class Builder
  end # class Router
end # module Subway
