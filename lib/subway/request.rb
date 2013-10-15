module Subway

  class Request

    include Anima.new(:raw)
    include Adamantium::Flat

    def self.coerce(raw)
      new(:raw => ::Request::Rack.new(raw))
    end

    def authenticated?
      false
    end

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
