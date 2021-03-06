# encoding: utf-8

module Subway
  module Handler
    class Responder

      # Builds an HTML response
      class HTML < self

        def call
          ::Response::HTML.build(body)
        end
      end
    end
  end
end
