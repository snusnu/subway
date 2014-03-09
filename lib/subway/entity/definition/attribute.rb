# encoding: utf-8

module Subway
  class Entity
    class Definition

      class Attribute

        include AbstractType
        include Concord::Public.new(:name)
        include Adamantium::Flat

        def node(environment)
          builder.call(self, environment)
        end

        def primitive?
          false
        end

      end # Attribute
    end # Definition
  end # Entity
end # Subway
