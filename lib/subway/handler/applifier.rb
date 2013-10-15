# encoding: utf-8

module Subway
  module Handler

    class Applifier

      extend  Handler
      include Concord.new(:request)

      def call
        Request.coerce(request.data)
      end
    end
  end
end
