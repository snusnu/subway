# encoding: utf-8

require 'dm-core'
require 'axiom'
require 'axiom-types'
require 'axiom-optimizer'
require 'axiom-do-adapter'

module Subway
  class Relation

    class Builder

      include AbstractType
      include Procto.call

      abstract_method :name
      abstract_method :header

      def call
        Axiom::Relation::Base.new(name, header)
      end

      class DM < self

        include Concord.new(:model)

        def name
          model.storage_names[:default].to_sym
        end

        def header
          model.properties.map { |p| [p.field, p.primitive] }
        end
      end # DataMapper
    end # Builder

    class Schema
      class Builder

        class DM < self

          include Concord.new(:models, :relation_builder)
          include Procto.call

          def initialize(models, relation_builder = Relation::Builder::DM)
            super
          end

          def call
            models.each_with_object({}) { |model, hash|
              relation = relation_builder.call(model)
              hash[relation.name] = relation
            }
          end

        end

        class Context

          include Concord::Public.new(:relations)

          def self.call(relations = {}, &block)
            new(relations, &block).relations
          end

          def initialize(relations, &block)
            super
            instance_eval(&block)
          end

          private

          def relation(name, &block)
            relations[name] = Schema::Context.call(relations, block)
          end
        end # Context

        include Adamantium::Flat
        include Concord.new(:relations, :block)
        include Procto.call

        def call
          Schema.new(Context.call(relations, &block))
        end
      end # Builder

      class Context < BasicObject

        def self.call(relations, block)
          new(relations, block).call
        end

        def initialize(relations, block)
          @relations, @block = relations, block
        end

        def call
          instance_eval(&@block).optimize
        end

        def inspect
          @relations.inspect
        end

        private

        def method_missing(name, *args, &block)
          super unless @relations.key?(name)
          @relations[name]
        end

        def respond_to_missing?(name, include_private = false)
          @relations.key?(name) or super
        end
      end # Context

      include Lupo.collection(:relations)

      def self.build(relations, &block)
        Builder.call(relations, block)
      end

      def [](name)
        relations.fetch(name)
      end
    end # Schema

    include Concord.new(:relation, :mapper)
    include Enumerable

    def each(&block)
      return to_enum unless block
      relation.each { |tuple| yield(mapper.load(tuple)) }
      self
    end

    def sort
      new(relation.sort)
    end

    def sort_by(*args, &block)
      new(relation.sort_by(*args, &block))
    end

    def one(&block)
      mapper.load(relation.one(&block))
    end

    def restrict(*args, &block)
      new(relation.restrict(*args, &block))
    end

    def wrap(*args)
      new(relation.wrap(*args))
    end

    def group(*args)
      new(relation.group(*args))
    end

    private

    def new(new_relation)
      self.class.new(new_relation, mapper)
    end
  end # Relation

  class Database

    include Concord.new(:name, :adapter, :relation_schema)

    def self.build(name, adapter, schema)
      new(name, adapter, relations(adapter, schema))
    end

    def self.relations(adapter, schema)
      schema.each_with_object({}) { |(name, relation), hash|
        if relation.respond_to?(:name)
          hash[name] = Axiom::Relation::Gateway.new(adapter, relation)
        else
          hash[name] = relation
        end
      }
    end

    def [](name)
      relation_schema.fetch(name)
    end

  end # Database

  class Schema

    class Definition

      def self.call(relations, mappers, &block)
        new(relations, mappers, &block).entries
      end

      attr_reader :entries

      def initialize(relations, mappers, &block)
        @relations, @mappers = relations, mappers
        @entries = {}
        instance_eval(&block) if block
      end

      def map(relation_name, mapper_name)
        entries[relation_name] = relation(relation_name, mapper_name)
      end

      def relation(relation_name, mapper_name)
        Relation.new(relations[relation_name], mappers.mapper(mapper_name))
      end

      private

      attr_reader :relations
      attr_reader :mappers

    end # Definition

    include Concord.new(:relations)

    def self.build(relations, mappers, &block)
      new(Definition.call(relations, mappers, &block))
    end

    def [](relation_name)
      relations[relation_name]
    end
  end # Schema
end # Subway
