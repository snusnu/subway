# encoding: utf-8

module Subway
  class Entity
    class Definition
      class Attribute

        class Entity < self

          attr_reader :entity_name
          attr_reader :block

          def initialize(name, options, block)
            super(name)
            @entity_name = options.fetch(:entity, name)
            @block       = block
          end

          def embed?
            !!block
          end

          private

          def builder
            Morpher::Builder::Attribute::Entity
          end
        end # Entity

        class Collection < Entity
          private

          def builder
            Morpher::Builder::Attribute::Collection
          end
        end # Collection

      end # Attribute
    end # Definition
  end # Entity
end # Subway
