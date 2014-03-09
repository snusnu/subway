# encoding: utf-8

module Subway
  class Entity
    class Morpher
      class Builder
        class Attribute

          class Primitive < self

            class Processed < self

              attr_reader :processor

              def initialize(attribute, environment)
                super
                options    = attribute.options
                @processor = environment.processor(attribute.processor, options)
              end
            end # Processed

            def call
              s(:key_symbolize, name, processor)
            end

            def processor
              s(:input) # don't process input
            end

          end # Primitive
        end # Attribute
      end # Builder
    end # Morpher
  end # Entity
end # Subway
