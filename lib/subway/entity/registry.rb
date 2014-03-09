# encoding: utf-8

module Subway
  class Entity

    class Registry
      include Concord.new(:entries)

      def [](name)
        entries.fetch(name)
      end
    end # Registry
  end # Entity
end # Subway
