module Subway

  class Session

    class Serializer

      include Concord.new(:name, :attributes, :box)

      def call(data)
        cookie = Cookie.new(name, MultiJson.dump(data))
        Cookie::Header.new(cookie.encrypt(box).encode, attributes)
      end
    end

    include AbstractType
    include Concord::Public.new(:actor, :data, :serializer)
    include Adamantium

    def authenticated?
      false
    end

    def authorized?
      false
    end

    def serialize
      cookie.to_s
    end
    memoize :serialize

    def cookie
      serializer.call(data.to_h)
    end
    memoize :cookie

    def to_h
      data.to_h
    end
    memoize :to_h

    class Authenticated < self

      def authorize
        Authorized.new(actor, data)
      end

      def authenticated?
        true
      end
    end # class Authenticated

    class Authorized < Authenticated
      def authorized?
        true
      end
    end # class Authorized
  end # class Session
end # module Subway
