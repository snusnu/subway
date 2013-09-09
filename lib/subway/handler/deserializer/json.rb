# encoding: utf-8

module Subway
  module Handler
    class Deserializer

      # Handler for deserializing {Request} data from JSON
      class JSON < self

        def self.deserialize(json)
          MultiJson.load(json)
        end

        private

        def deserialize(json)
          self.class.deserialize(json)
        end

      end # class MultiJson
    end # class Deserializer
  end # module Handler
end # module Subway
