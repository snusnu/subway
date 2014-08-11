# encoding: utf-8

module Subway

  class Presenter
    include AbstractType
    include Concord.new(:data)
    include Adamantium::Flat

    def self.group(name, klass = nil)
      collection_presenter = klass || self::Collection
      define_method(name) do
        collection_presenter.new(super())
      end
      memoize(name)
    end

    def method_missing(name, *args, &block)
      @data.public_send(name, *args, &block)
    end

    def respond_to?(name, include_private = false)
      super || @data.respond_to?(name, include_private)
    end

    class Collection < self
      include Enumerable

      def self.member(presenter = Undefined)
        return @member if presenter.equal?(Undefined)
        @member = presenter
      end

      alias_method :members, :data

      def each
        return to_enum unless block_given?
        members.each { |member| yield self.class.member.new(member) }
        self
      end
    end
  end
end
