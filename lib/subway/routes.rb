# encoding: utf-8

module Subway

  # Module class providing the route definition DSL
  class Routes < Module

    include HTTP
    include Concord.new(:routes)
    include Adamantium::Flat

    def extended(host)
      routes = @routes # support the closure
      host.singleton_class.class_eval do
        [GET, POST, PUT, DELETE].each do |request_method|
          define_method(request_method) do |action, path, options = EMPTY_HASH|
            routes.add(action, Route::Config.new(request_method, path, options))
          end
        end
      end
    end
  end # class Routes
end # module Subway
