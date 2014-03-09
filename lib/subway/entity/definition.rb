# encoding: utf-8

module Subway
  class Entity

    class Definition

      include Concord.new(:entity_name, :header, :defaults)

      public :entity_name
      public :defaults

      def self.build(entity_name, header = EMPTY_ARRAY, defaults = EMPTY_HASH, &block)
        instance = new(entity_name, header.dup, defaults.dup)
        instance.instance_eval(&block) if block
        instance
      end

      def self.new(entity_name, header, defaults = EMPTY_HASH)
        super(entity_name, header.dup, defaults.dup)
      end

      def map(name, processor = Undefined, options = EMPTY_HASH)
        defaults[name.to_s] = options[:default] if options.key?(:default)
        header << Attribute::Primitive.build(name, processor, options)
      end

      def wrap(name, options = {entity: name}, &block)
        header << Attribute::Entity.new(name, options, block)
      end

      def group(name, options = {entity: name}, &block)
        header << Attribute::Collection.new(name, options, block)
      end

      def embedded_entities
        header.reject { |attribute| attribute.primitive? }
      end

      def attribute_nodes(environment)
        header.map { |attribute| attribute.node(environment) }
      end

      def attribute_names
        header.map(&:name)
      end

    end # Definition
  end # Entity
end # Subway
