# encoding: utf-8

module Subway
  class Entity
    class Morpher
      class Builder

        class Entity

          include AbstractType
          include Concord.new(:builder, :definition, :environment)
          include ::Morpher::NodeHelpers

          REGISTRY = {}

          abstract_method :processors

          def self.call(builder, *args)
            REGISTRY.fetch(builder).new(builder, *args).call
          end

          def self.register(builder)
            REGISTRY[builder] = self
          end
          private_class_method :register

          class HashTransformer < self
            register :hash

            private

            def processors
              EMPTY_ARRAY
            end
          end

          class ObjectMapper < self
            register :object

            private

            def processors
              [environment.model_processor(definition)]
            end
          end

          def call
            s(:block,
              s(:guard, s(:primitive, Hash)),
              *defaults,
              s(:hash_transform, *attributes),
              *processors
            )
          end

          private

          def attributes
            definition.attribute_nodes(environment, builder)
          end

          def defaults
            values = definition.defaults
            values.any? ? [ s(:merge, values) ] : EMPTY_ARRAY
          end

        end # Entity
      end # Builder
    end # Morpher
  end # Entity
end # Subway
