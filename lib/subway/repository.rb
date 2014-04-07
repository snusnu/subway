# encoding: utf-8

module Subway

  class Repository

    class Builder

      class Gateway

        TYPE_MAP = {
          DataMapper::Property::Serial  => Integer,
          DataMapper::Property::String  => String,
          DataMapper::Property::Integer => Integer,
          # this is obviously incomplete ...
        }.freeze

        include Adamantium::Flat
        include Concord.new(:model, :adapter)
        include Procto.call

        def call
          Axiom::Relation::Gateway.new(adapter, relation)
        end

        private

        def relation
          Axiom::Relation::Base.new(name, header)
        end

        def name
          model.storage_names[:default].to_sym
        end

        def header
          model.properties.map { |p| [p.name, TYPE_MAP.fetch(p.class)] }
        end

      end # Relation

      include Adamantium::Flat
      include Concord.new(:models, :adapter)
      include Procto.call

      def call
        Repository.new(registry)
      end

      private

      def registry
        models.each_with_object({}) { |model, hash|
          relation = Gateway.call(model, adapter)
          hash[relation.name] = relation
        }
      end

    end # Builder

    include Concord.new(:registry)

    def self.build(uri, models)
      Builder.call(models, Axiom::Adapter::DataObjects.new(uri))
    end

    def [](relation_name)
      registry.fetch(relation_name)
    end

  end # Repository
end # Subway
