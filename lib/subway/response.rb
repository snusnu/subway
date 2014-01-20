module Subway

  class Response
    include Concord.new(:http, :data)

    public :data

    def with_cookie
      new(http.with_cookie(data.cookie))
    end

    def to_rack_response
      http.to_rack_response
    end

    private

    def new(new_http, new_data = data)
      self.class.new(new_http, new_data)
    end

    class Data

      # {
      #   "resource": {},
      #   "location": "/some/path",
      #   "messages": [{}],
      #   "errors": [
      #     {
      #       "input": "name",
      #       "messages": ["Unknown login"]
      #     }
      #   ]
      # }

      include Anima.new(:cookie, :messages)
      include Adamantium
      include AbstractType

      def self.build(attributes)
        new({ :cookie => EMPTY_STRING }.merge(attributes))
      end

      class Success < self
        include anima.add(:location)
      end

      class Redirect < self
        include anima.add(:location)
      end

      class Failure < self
        include anima.add(:resource, :errors)
      end

    end # class Data
  end # class Response
end # module Subway
