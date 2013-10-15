# encoding: utf-8

module Subway
  module Handler

    # Abstract baseclass for constructing HTTP redirect responses
    class Redirector

      extend  Handler
      include Equalizer.new(:response)
      include AbstractType

      abstract_method :call

      attr_reader :response
      protected   :response

      attr_reader :data
      private     :data

      def initialize(response)
        @response = response
        @data     = @response.data
      end
    end
  end
end
