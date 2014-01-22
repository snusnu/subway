# encoding: utf-8

module Subway
  module Handler
    class Deserializer
      class JSON

        class Body < self

          def initialize(input)
            super(input.body)
          end

          def call
            deserialize(data)
          end
        end
      end # JSON
    end # Deserializer
  end # Handler
end # Subway
