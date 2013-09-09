# encoding: utf-8

module Subway

  # A collection of {Route} instances keyed by {#name}
  class RouteSet
    include Concord.new(:routes)
    include Enumerable

    def each(&block)
      return to_enum unless block
      routes.each(&block)
      self
    end
  end # class RouteSet
end # module Subway
