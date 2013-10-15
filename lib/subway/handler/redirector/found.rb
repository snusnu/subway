# encoding: utf-8

module Subway
  module Handler
    class Redirector

      # Builds an HTML response
      class Found < self

        def call
          Response.new(::Response::Redirect::Found.build(data.location), data)
        end
      end
    end
  end
end
