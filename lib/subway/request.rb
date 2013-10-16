module Subway

  class Request

    include Anima.new(:raw)
    include Adamantium::Flat

    ROUTER_PARAMS_RACK_ENV_KEY = 'router.params'.freeze

    def self.coerce(raw)
      new(:raw => ::Request::Rack.new(raw))
    end

    def authenticated?
      false
    end

    def path_params
      raw.rack_env[ROUTER_PARAMS_RACK_ENV_KEY]
    end
    memoize :path_params

    def query_params
      raw.query_params_hash
    end
    memoize :query_params

    def cookies
      raw.cookies
    end
    memoize :cookies

    def body
      raw.body
    end
    memoize :body

    def authenticated(session)
      Authenticated.new(:raw => raw, :session => session)
    end

    class Authenticated < self

      include anima.add(:session)

      def authenticated?
        true
      end

      def session_cookie
        session.cookie
      end
    end # class Authenticated
  end # class Request
end # module Subway
