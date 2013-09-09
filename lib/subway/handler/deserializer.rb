# encoding: utf-8

module Subway
  module Handler

    # Base class for substation handlers that provide deserialization
    #
    # @abstract
    class Deserializer

      extend  Handler
      include Concord.new(:data)
      include AbstractType

      DECOMPOSER = ->(request) { request.data }
      COMPOSER   = ->(request, output) { output }
      EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      abstract_method :deserialize
      private         :deserialize

      def call
        deserialize(data)
      end

    end # class Deserializer
  end # module Handler
end # module Subway
