module Subway

  class Request

    include Anima.new(:raw)
    include Adamantium::Flat

    COMMA = ','.freeze
    DOT   = '.'.freeze

    ROUTER_PARAMS_RACK_ENV_KEY        = 'router.params'.freeze
    SERVER_NAME_RACK_ENV_KEY          = 'SERVER_NAME'.freeze
    REMOTE_ADDR_RACK_ENV_KEY          = 'REMOTE_ADDR'.freeze
    HTTP_X_FORWARDED_FOR_RACK_ENV_KEY = 'HTTP_X_FORWARDED_FOR'.freeze

    LOCALHOST_REGEXP = Regexp.union([
      /\A127\.0\.0\.\d{1,3}\z/,
      /\A::1\z/,
      /\A0:0:0:0:0:0:0:1(%.*)?\z/
    ]).freeze

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
    memoize :body, freezer: :noop

    def subdomains(domain)
      if localhost? || valid_host?
        host.sub(/\.?#{domain}.*$/, EMPTY_STRING).split(DOT)
      else
        EMPTY_ARRAY
      end
    end

    # TODO
    #
    # Try refactoring the need for this away,
    # currently our base action assigns
    #
    #   @actor = request.input.actor
    #
    # Alternatively, think about being able to
    # inject an Actor::Unknown
    #
    def actor
      nil
    end

    def authenticated(session)
      Authenticated.new(:raw => raw, :session => session)
    end

    private

    def host
      raw.host
    end
    memoize :host

    def localhost?
      LOCALHOST_REGEXP =~ remote_addr && LOCALHOST_REGEXP =~ remote_ip
    end
    memoize :localhost?

    def valid_host?
      IPAddress.valid?(server_name)
    end
    memoize :valid_host?

    def server_name
      rack_env[SERVER_NAME_RACK_ENV_KEY]
    end
    memoize :server_name

    def remote_addr
      rack_env[REMOTE_ADDR_RACK_ENV_KEY]
    end
    memoize :remote_addr

    def remote_ip
      if addr = rack_env[HTTP_X_FORWARDED_FOR_RACK_ENV_KEY]
        (addr.split(COMMA).grep(/\d\./).first || remote_addr).to_s.strip
      else
        remote_addr
      end
    end
    memoize :remote_ip

    def rack_env
      raw.rack_env
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

      def actor
        session.actor
      end
    end # class Authenticated

  end # class Request
end # module Subway
