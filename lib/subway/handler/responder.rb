# encoding: utf-8

module Subway
  module Handler

    # Abstract baseclass for turning a {Response} into a HTTP response
    class Responder

      extend  Handler
      include Equalizer.new(:response)
      include AbstractType

      abstract_method :call

      attr_reader :response
      protected   :response

      attr_reader :body
      private     :body

      def initialize(response)
        @response = response
        @body     = @response.data
      end
    end
  end
end
