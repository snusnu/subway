# encoding: utf-8

module Subway
  module Handler
    module Cookie

      class Loader

        include Substation::Processor::Evaluator::Handler
        include Anima.new(:name, :location, :box)

        def call(request)
          if cookie = request.input.cookies.get(name)
            credentials = cookie.decode.decrypt(box).value rescue nil
            credentials ? success(credentials) : error(error_response)
          else
            error(error_response)
          end
        end

        private

        def error_response
          Response::Data::Redirect.new(
            :cookie   => nil,
            :location => location,
            :messages => EMPTY_ARRAY
          )
        end

      end # Loader
    end # Cookie
  end # Handler
end# Subway
