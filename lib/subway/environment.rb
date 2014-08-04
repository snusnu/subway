# encoding: utf-8

module Subway
  class Environment

    include Concord.new(:name, :services)

    public :name

    def self.new(name, services = EMPTY_HASH)
      super(name.to_sym, services.dup)
    end

    def register(other_services)
      self.class.new(services.merge(other_services))
    end

    private

    def method_missing(name, *args, &block)
      return super unless services.key?(name)
      services[name]
    end

    def respond_to_missing?(name, include_private = false)
      super || services.key?(name)
    end
  end # Environment
end # Subway
