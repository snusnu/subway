# encoding: utf-8

module Subway
  module Handler

    # Turns a rack request into a {Request} instance
    class Applifier

      extend  Handler
      include Concord.new(:request)

      DECOMPOSER = ->(request) { request }
      COMPOSER   = ->(response, output) { output }
      EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      def call
        Request::Rack.new(request.data)
      end
    end
  end
end
