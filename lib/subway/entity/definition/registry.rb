# encoding: utf-8

module Subway
  class Entity
    class Definition

      class Registry

        class AlreadyRegistered < StandardError
          def initialize(name)
            super("#{name.inspect} is already registered")
          end
        end # AlreadyRegistered

        include Lupo.collection(:entries)

        def self.build(entries = {}, &block)
          instance = new(entries)
          instance.instance_eval(&block) if block
          instance
        end

        def self.new(entries = {})
          super
        end

        def register(name, &block)
          if entries.key?(name)
            fail(AlreadyRegistered.new(name))
          else
            entries[name] = Definition.build(name, &block)
          end
        end

        def [](name)
          entries.fetch(name)
        end

        def models(builder_name)
          Model::Builder.call(builder_name, self)
        end

        def environment(models, processors = PROCESSORS)
          Environment.new(
            definitions: self,
            models: models,
            processors: processors
          )
        end

      end # Registry
    end # Definition
  end # Entity
end # Subway
