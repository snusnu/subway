# encoding: utf-8

module Subway
  module Handler
    class Serializer

      # Handler for serializing response data to JSON
      class JSON < self

        def self.serialize(json)
          MultiJson.dump(json)
        end

        private

        def serialize(json)
          self.class.serialize(json)
        end

      end # class MultiJson
    end # class Serializer
  end # module Handler
end # module Subway
