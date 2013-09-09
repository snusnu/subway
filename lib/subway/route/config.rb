# encoding: utf-8

module Subway
  class Route

    # Holds {Route} configuration
    class Config
      include Concord::Public.new(:request_method, :path, :options)
      include Adamantium
    end # class Config
  end # class Route
end # module Subway
