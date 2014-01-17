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

    def params
      path_params.merge(query_params)
    end
    memoize :params

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

      def sanitized(params)
        Sanitized.new(to_h.merge(params: params))
      end

      def authenticated?
        true
      end

      def session_cookie
        session.cookie
      end
    end # class Authenticated

    class Sanitized < Authenticated
      include anima.add(:params)
    end
  end # class Request
end # module Subway
