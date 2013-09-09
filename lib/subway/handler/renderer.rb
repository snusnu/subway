# encoding: utf-8

module Subway
  module Handler

    # Abstract baseclass for handlers that render a response
    #
    # @abstract
    class Renderer

      extend  Handler
      include Concord.new(:view)
      include AbstractType

      DECOMPOSER = ->(response) { response.data }
      COMPOSER   = ->(response, output) { output }
      EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      abstract_method :call

    end
  end
end
