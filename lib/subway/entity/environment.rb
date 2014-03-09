# encoding: utf-8

module Subway
  class Entity

    extend ::Morpher::NodeHelpers

    PROCESSORS = {

      ParsedInt10:      ->(_) { s(:parse_int, 10) },
      ParsedInt10Array: ->(_) { s(:map, s(:parse_int, 10)) },

      String:           ->(_) { s(:guard, s(:primitive, String)) },
      Integer:          ->(_) { s(:guard, s(:is_a,      Integer)) },
      DateTime:         ->(_) { s(:guard, s(:primitive, DateTime)) },
      Boolean:          ->(_) { s(:guard, s(:or, s(:primitive, TrueClass), s(:primitive, FalseClass))) },

      OString:          ->(_) { s(:guard, s(:or, s(:primitive, String),   s(:primitive, NilClass))) },
      OInteger:         ->(_) { s(:guard, s(:or, s(:is_a,      Integer),  s(:primitive, NilClass))) },
      ODateTime:        ->(_) { s(:guard, s(:or, s(:primitive, DateTime), s(:primitive, NilClass))) },

      IntArray:         ->(_) { s(:map, s(:guard, s(:is_a,      Integer))) },
      StringArray:      ->(_) { s(:map, s(:guard, s(:primitive, String))) },

    }.freeze

    class Environment

      include Anima.new(
        :definitions,
        :processors,
        :models
      )

      DEFAULTS = {
        processors: PROCESSORS
      }.freeze

      def self.new(attributes)
        super(DEFAULTS.merge(attributes))
      end

      def morpher(entity_name, &block)
        Morpher.build(Definition.build(entity_name, &block), self)
      end

      def mapper(entity_name)
        Mapper.build(definitions[entity_name], self)
      end

      def processor(name, options)
        processors.fetch(name).call(options)
      end

      def model(name)
        models[name]
      end

      def model_processor(definition)
        models.processor(definition)
      end

    end # Environment
  end # Entity
end # Subway
