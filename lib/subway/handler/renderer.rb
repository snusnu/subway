# encoding: utf-8

module Subway
  module Handler

    # Abstract baseclass for handlers that render a response
    #
    # @abstract
    class Renderer

      extend  Handler
      include AbstractType

      abstract_method :call

      attr_reader :view
      private     :view

      def initialize(response)
        @view = response.data
      end

    end
  end
end
