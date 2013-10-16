# encoding: utf-8

module Subway
  module Handler
    module Cookie
      class Dumper

        extend Handler

        attr_reader :output
        private     :output

        def initialize(response)
          @output = response.output
        end

        def call
          output.with_cookie
        end
      end
    end
  end
end
