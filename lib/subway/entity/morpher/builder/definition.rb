# encoding: utf-8

module Subway
  class Entity
    class Morpher
      class Builder

        class Definition

          include Concord.new(:definition, :environment)
          include ::Morpher::NodeHelpers

          def self.call(definition, environment)
            new(definition, environment).call
          end

          def call
            s(:block,
              s(:guard, s(:primitive, Hash)),
              *defaults,
              s(:hash_transform, *definition.attribute_nodes(environment)),
              environment.model_processor(definition)
            )
          end

          private

          def defaults
            values = definition.defaults
            values.any? ? [ s(:merge, values) ] : []
          end

        end # Definition
      end # Builder
    end # Morpher
  end # Entity
end # Subway
