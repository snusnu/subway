# encoding: utf-8

module Subway
  module Handler

    # Handler for turning a {Response} into a rack response
    class Rackifier

      extend  Handler
      include Substation::Processor::Outgoing
      include Concord.new(:response)

      DECOMPOSER = ->(response) { response.data }
      COMPOSER   = ->(response, output) { output }
      EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      def call
        response.to_rack_response
      end
    end
  end
end
