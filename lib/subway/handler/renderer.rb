# encoding: utf-8

module Subway
  module Handler

    # Abstract baseclass for handlers that render a response
    #
    # @abstract
    class Renderer

      extend  Handler
      include Concord.new(:view)
      include AbstractType

      abstract_method :call

    end
  end
end
