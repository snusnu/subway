# encoding: utf-8

module Subway
  module Handler

    class Morpher

      module Helper

        include ::Morpher::NodeHelpers

        def mapper(model, attributes, defaults = EMPTY_HASH)
          s(:block,
            s(:guard, s(:primitive, Hash)),
            s(:merge, defaults),
            s(:hash_transform, *attributes),
            s(:load_attribute_hash, s(:param, model))
           )
        end
      end

      class Proxy

        include Concord.new(:evaluator)
        include Memoizable

        def call(input)
          success(evaluator.call(input))
        rescue ::Morpher::Evaluator::Transformer::TransformError
          error(evaluator.evaluation(input))
        end

        def node
          evaluator.node
        end
        memoize :node

        private

        def success(output)
          Substation::Processor::Evaluator::Result::Success.new(output)
        end

        def error(output)
          Substation::Processor::Evaluator::Result::Failure.new(output)
        end
      end # Proxy

      def self.evaluator(node)
        Proxy.new(::Morpher.compile(node))
      end

    end # Morpher
  end # Handler
end # Subway
