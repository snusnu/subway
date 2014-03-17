# encoding: utf-8

module Subway
  class Entity
    class Morpher
      class Builder
        class Attribute

          class Primitive < self

            private

            def node
              environment.processor(attribute.processor, attribute.options)
            end
          end # Primitive
        end # Attribute
      end # Builder
    end # Morpher
  end # Entity
end # Subway
