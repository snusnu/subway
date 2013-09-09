# encoding: utf-8

module Subway

  # Namespace for all substation handlers
  module Handler

    include Adamantium::Flat

    def call(state)
      new(state).call
    end
  end # module Handler
end # module Subway
