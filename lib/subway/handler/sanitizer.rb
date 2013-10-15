# encoding: utf-8

module Subway
  module Handler

    module Sanitizer

      DECOMPOSER = ->(request) { request.input }
      COMPOSER   = ->(request, output) { output }
      EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

    end
  end
end
