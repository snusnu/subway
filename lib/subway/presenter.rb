# encoding: utf-8

module Subway

  class Presenter
    include AbstractType
    include Concord.new(:data)
    include Adamantium::Flat

    def self.group(name, klass = nil)
      define_method(name) do
        (klass || self.class::Collection).new(super())
      end
      memoize(name)
    end

    def method_missing(method, *args, &block)
      @data.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      super || @data.respond_to?(method, include_private)
    end

    class Collection < self
      include Enumerable

      def self.member(presenter = Undefined)
        return @member if presenter.equal?(Undefined)
        @member = presenter
      end

      alias_method :members, :data

      protected :members

      def each
        return to_enum unless block_given?
        members.each { |member| yield self.class.member.new(member) }
        self
      end
    end
  end
end
