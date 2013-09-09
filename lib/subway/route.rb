# encoding: utf-8

module Subway

  # A named route with access to its {Config}
  class Route
    include Concord.new(:name, :config)
    include Adamantium

    public(:name)

    def path
      config.path
    end
    memoize :path

    def request_method
      config.request_method
    end
    memoize :request_method

    def options
      config.options
    end
    memoize :options
  end # class Route
end # module Subway
