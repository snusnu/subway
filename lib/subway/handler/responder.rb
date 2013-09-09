# encoding: utf-8

module Subway
  module Handler

    # Abstract baseclass for turning a {Response} into a HTTP response
    class Responder

      extend  Handler
      include Concord.new(:data)
      include AbstractType

      DECOMPOSER = ->(response) { response.data }
      COMPOSER   = ->(response, output) { output }
      EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      abstract_method :call
    end
  end
end
