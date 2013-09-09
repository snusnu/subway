# encoding: utf-8

module Subway
  module Handler

    # Base class for substation handlers that provide serialization
    #
    # @abstract
    class Serializer
      extend  Handler
      include Concord.new(:data)
      include AbstractType

      DECOMPOSER = ->(response) { response.data }
      COMPOSER   = ->(response, output) { output }
      EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      abstract_method :serialize
      private         :serialize

      def call
        serialize(data)
      end

    end # class Serializer
  end # module Handler
end # module Subway
