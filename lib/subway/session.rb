module Subway

  class Session

    class Serializer

      include Concord.new(:name, :attributes, :box)

      def call(data)
        Cookie::Header.new(cookie(data).encrypt(box).encode, attributes)
      end

      private

      def cookie(data)
        Cookie.new(name, MultiJson.dump(data))
      end
    end

    include Concord.new(:actor, :data, :serializer)
    include Adamantium

    public :actor

    def serialize
      cookie.to_s
    end
    memoize :serialize

    def cookie
      serializer.call(to_h)
    end
    memoize :cookie

    def to_h
      data.to_h
    end
    memoize :to_h

  end # class Session
end # module Subway
