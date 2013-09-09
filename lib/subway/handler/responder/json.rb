# encoding: utf-8

module Subway
  module Handler
    class Responder

      # Builds a JSON response
      class JSON < self

        def call
          Response::JSON.build(Array(data))
        end
      end
    end
  end
end
