# encoding: utf-8

module Subway
  class Entity
    class Mapper

      def self.build(definition, environment)
        new(Morpher.build(definition, environment))
      end

      attr_reader :loader
      attr_reader :dumper

      def initialize(evaluator)
        @loader = evaluator
        @dumper = evaluator.inverse
      end

      def load(tuple)
        loader.call(tuple)
      end

      def dump(object)
        dumper.call(object)
      end

    end # Mapper
  end # Entity
end # Subway
