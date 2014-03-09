# encoding: utf-8

require 'concord'
require 'anima'
require 'morpher'
require 'adamantium'
require 'abstract_type'
require 'lupo'

module Subway
  class Entity

    # An undefined value useful for default params
    Undefined = Class.new.freeze

    # An empty frozen array
    EMPTY_ARRAY = [].freeze

    # An empty frozen array
    EMPTY_HASH = {}.freeze

    def self.registry(environment)
      Registry.new(environment.definitions.each_with_object({}) {
        |(name, definition), hash|
        hash[name] = build(definition, environment)
      })
    end

    def self.build(definition, environment)
      name   = definition.entity_name
      model  = environment.model(name)
      mapper = Mapper.build(definition, environment)

      new(name, model, mapper)
    end
    private_class_method :build

    include Concord::Public.new(:name, :model, :mapper)

    def new(attributes)
      model.new(attributes)
    end

    def load(tuple)
      mapper.load(tuple)
    end

    def dump(object)
      mapper.dump(object)
    end
  end # Entity
end # Subway

require 'subway/entity/definition'
require 'subway/entity/definition/registry'
require 'subway/entity/definition/attribute'
require 'subway/entity/definition/attribute/primitive'
require 'subway/entity/definition/attribute/embedded'
require 'subway/entity/morpher/builder/attribute'
require 'subway/entity/morpher/builder/attribute/primitive'
require 'subway/entity/morpher/builder/attribute/embedded'
require 'subway/entity/morpher/builder/definition'
require 'subway/entity/morpher'
require 'subway/entity/morpher/registry'
require 'subway/entity/model/registry'
require 'subway/entity/model/builder'
require 'subway/entity/model/builder/anima'
require 'subway/entity/mapper'
require 'subway/entity/environment'
require 'subway/entity/registry'
