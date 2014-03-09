# encoding: utf-8

module Subway
  class Entity
    class Morpher
      class Builder

        class Attribute

          include AbstractType
          include Adamantium::Flat
          include ::Morpher::NodeHelpers

          def self.call(attribute, environment)
            new(attribute, environment).call
          end

          abstract_method :call

          attr_reader :name
          private     :name

          attr_reader :environment
          private     :environment

          attr_reader :definitions
          private     :definitions

          attr_reader :processors
          private     :processors

          attr_reader :models
          private     :models

          def initialize(attribute, environment)
            @attribute   = attribute
            @name        = attribute.name
            @environment = environment
            @definitions = environment.definitions
            @processors  = environment.processors
            @models      = environment.models
          end

        end # Attribute
      end # Builder
    end # Morpher
  end # Entity
end # Subway
