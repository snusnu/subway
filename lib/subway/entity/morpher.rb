# encoding: utf-8

module Subway
  class Entity
    class Morpher

      class TransformError < StandardError
        include Concord.new(:evaluation)

        private

        def method_missing(name, *args, &block)
          evaluation.public_send(name)
        end

        def respond_to?(name, include_ancestors = true)
          evaluation.respond_to?(name, include_ancestors)
        end
      end

      include Concord.new(:evaluator)

      def self.build(definition, environment)
        node = Builder::Definition.call(definition, environment)
        new(::Morpher.compile(node))
      end

      def call(input)
        evaluator.call(input)
      rescue ::Morpher::Evaluator::Transformer::TransformError
        raise(TransformError, evaluation(input))
      end

      def evaluation(input)
        evaluator.evaluation(input)
      end

      def inverse
        self.class.new(evaluator.inverse)
      end

    end # Morpher
  end # Entity
end # Subway
