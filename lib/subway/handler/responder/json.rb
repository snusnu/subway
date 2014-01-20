# encoding: utf-8

module Subway
  module Handler
    class Responder

      # Builds a JSON response
      class JSON < self

        def call
          Response.new(http_response, body)
        end

        private

        def http_response
          ::Response::JSON.build(MultiJson.dump(data))
        end

        def data
          body.to_h
        end

        class NotAuthorized < self
          private

          def http_response
            super.with_status(::Response::Status::NOT_AUTHORIZED)
          end
        end

        class Forbidden < self
          private

          def http_response
            super.with_status(::Response::Status::FORBIDDEN)
          end
        end
      end
    end
  end
end
