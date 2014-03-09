# encoding: utf-8

module Subway
  class Entity
    class Definition
      class Attribute

        class Primitive < self

          class Processed < self

            attr_reader :processor
            attr_reader :options

            def initialize(name, processor, options)
              super(name)
              @processor = processor
              @options   = options.dup
            end

            private

            def builder
              Morpher::Builder::Attribute::Primitive::Processed
            end
          end # Processed


          def self.build(name, processor, options)
            if processor.equal?(Undefined)
              new(name)
            else
              Processed.new(name, processor, options)
            end
          end

          def primitive?
            true
          end

          private

          def builder
            Morpher::Builder::Attribute::Primitive
          end
        end # Primitive
      end # Attribute
    end # Definition
  end # Entity
end # Subway
