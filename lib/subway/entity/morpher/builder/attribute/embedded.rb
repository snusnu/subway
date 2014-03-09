# encoding: utf-8

module Subway
  class Entity
    class Morpher
      class Builder
        class Attribute
          class Entity < self

            include AbstractType

            def self.new(attribute, environment)
              return super if self < Entity
              klass = attribute.embed? ? Embedded : Referenced
              klass.new(attribute, environment)
            end

            attr_reader :entity_name
            attr_reader :definition

            def initialize(attribute, environment)
              super
              @entity_name = attribute.entity_name
            end

            def call
              s(:key_symbolize, name, Definition.call(definition, environment))
            end

            class Embedded < self

              def initialize(attribute, environment)
                super
                @definition = Subway::Entity::Definition.build(entity_name, &attribute.block)
              end
            end # Embedded

            class Referenced < self

              def initialize(attribute, environment)
                super
                @definition = definitions[entity_name]
              end
            end # Referenced
          end # Entity

          module Collection

            def self.call(attribute, environment)
              new(attribute, environment).call
            end

            def self.new(attribute, environment)
              return super if self < Entity
              klass = attribute.embed? ? Embedded : Referenced
              klass.new(attribute, environment)
            end

            def call
              s(:key_symbolize, name, node)
            end

            private

            def node
              s(:map, Definition.call(definition, environment))
            end

            class Embedded < Entity::Embedded
              include Collection
            end

            class Referenced < Entity::Referenced
              include Collection
            end
          end # Collection

        end # Attribute
      end # Builder
    end # Morpher
  end # Entity
end # Subway

