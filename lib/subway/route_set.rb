# encoding: utf-8

module Subway

  # A collection of {Route} instances keyed by {#name}
  class RouteSet
    include Lupo.collection(:routes)
  end # class RouteSet
end # module Subway
