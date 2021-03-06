# encoding: utf-8

module Subway

  class Facade
    include Lupo.collection(:scopes)

    def scope(name, &block)
      Proxy.build(scopes[name], &block)
    end

    class Proxy
      def self.build(scope, &block)
        proxy = new(scope)
        proxy.instance_eval(&block) if block
        proxy
      end

      def initialize(scope)
        @name, @dispatcher = scope.name, scope.dispatcher
      end

      private

      def method_missing(name, *args, &block)
        action = action_name(name)
        if @dispatcher.include?(action)
          @dispatcher.call(action, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(name, include_private = false)
        super || @dispatcher.include?(action_name(name))
      end

      def action_name(name)
        :"#{@name}_#{name}"
      end
    end # Proxy

    class Definition
      include Lupo.collection(:scopes)

      def self.new(scopes = EMPTY_HASH)
        super(scopes.dup)
      end

      def register(name, environment, options = Scope::Options::DEFAULT, &block)
        scopes[name] = Scope.build(name, environment, options, &block)
      end

      def facade
        Facade.new(self)
      end

      def [](name)
        scopes.fetch(name) { raise UnknownFacadeScope.new(name) }
      end
    end # Definition

    class Scope

      class Options

        include Anima.new(:base, :on_exception)

        DEFAULT = {
          base:         Substation::Chain::EMPTY,
          on_exception: Substation::Chain::EMPTY
        }.freeze

        def self.build(options)
          new(DEFAULT.merge(options))
        end

      end # Options

      def self.build(name, environment, options, &block)
        instance = new(name, environment, Options.build(options))
        instance.instance_eval(&block)
        instance
      end

      include Equalizer.new(:name, :environment, :options)
      include Lupo.enumerable(:actions)

      attr_reader :name
      attr_reader :actions
      attr_reader :dispatcher

      attr_reader :environment
      protected   :environment

      attr_reader :options
      protected   :options

      attr_reader :base
      attr_reader :exception_chain

      def initialize(name, environment, options)
        @name            = name
        @environment     = environment
        @dispatcher      = @environment.dispatcher
        @base            = options.base
        @exception_chain = options.on_exception
        @actions         = []
      end

      def resource(name, &block)
        Resource.build(name, self, &block)
      end

      def register(name, base = base, exception_chain = exception_chain, &block)
        environment.register(name, base, exception_chain, &block)
        actions << name
        self
      end
    end # Scope

    class Resource

      def self.id(action, scope, detail, name)
        :"#{scope}_#{action}_#{detail}#{name}"
      end
      private_class_method :id

      NAMES = {
        list:   ->(scope, detail, name) { id(:list,   scope, detail, Inflecto.pluralize(name)) },
        show:   ->(scope, detail, name) { id(:show,   scope, detail, name) },
        new:    ->(scope, detail, name) { id(:new,    scope, detail, name) },
        create: ->(scope, detail, name) { id(:create, scope, detail, name) },
        edit:   ->(scope, detail, name) { id(:edit,   scope, detail, name) },
        update: ->(scope, detail, name) { id(:update, scope, detail, name) },
        delete: ->(scope, detail, name) { id(:delete, scope, detail, name) },
      }.freeze

      attr_reader :name
      attr_reader :scope

      attr_reader :base
      private     :base

      attr_reader :exception_chain
      private     :exception_chain

      def self.build(name, scope, &block)
        instance = new(name, scope)
        instance.instance_eval(&block)
        instance
      end

      def initialize(name, scope)
        @name, @scope    = name, scope
        @base            = scope.base
        @exception_chain = scope.exception_chain
      end

      NAMES.keys.each do |action|
        define_method action do |detail = nil, base = base, chain = exception_chain, &block|
          register(__method__, detail, name, base, chain, &block)
        end
      end

      private

      def register(action, detail, name, base, chain, &block)
        scope.register(id(action, detail, name), base, chain, &block)
      end

      def id(action, detail, name)
        NAMES[action].call(scope.name, query(detail), name)
      end

      def query(detail)
        detail ? "#{detail}_" : EMPTY_STRING
      end

    end # Resource
  end # Facade
end # Subway
