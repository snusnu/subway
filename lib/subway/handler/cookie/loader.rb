# encoding: utf-8

module Subway
  module Handler
    module Cookie

      class Loader

        include Substation::Processor::Evaluator::Handler
        include Anima.new(:name, :location, :box)

        def call(request)
          cookie = request.input.cookies.get(name)
          cookie ? success(credentials(cookie)) : error(error_response(cookie))
        end

        private

        def credentials(cookie)
          cookie.decode.decrypt(box).value
        end

        def error_response(cookie)
          Response::Data::Redirect.new(
            :cookie   => cookie,
            :location => location,
            :messages => EMPTY_ARRAY
          )
        end
      end
    end
  end
end
