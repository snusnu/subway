# encoding: utf-8

module Subway
  module Handler
    class Responder

      # Builds a JSON response
      class JSON < self

        def call
          Response.new(::Response::JSON.build(json_body), body)
        end

        private

        def json_body
          MultiJson.dump(body.to_h)
        end

        class NotAuthorized < self
          def call
            super.with_status(::Response::Status::NOT_AUTHORIZED)
          end
        end

        class Forbidden < self
          def call
            super.with_status(::Response::Status::FORBIDDEN)
          end
        end
      end
    end
  end
end
