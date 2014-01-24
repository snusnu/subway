# encoding: utf-8

module Subway
  module Handler

    class Morpher

      module Helper

        def s(type, *children)
          ::Morpher::NodeHelpers.s(type, *children)
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
        Proxy.new(::Morpher.evaluator(node))
      end

    end # Morpher
  end # Handler
end # Subway
