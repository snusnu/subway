# encoding: utf-8

module Subway
  module Handler

    class Validator

      include Concord.new(:validations)

      def call(request)
        violations = validate(request.input.params)

        if violations.empty?
          request.success(request.input)
        else
          request.error(violations)
        end
      end

      private

      def validate(params)
        validations.each_with_object({}) { |(name, validator), errors|
          result = validator.call(params.public_send(name))
          unless result.success?
            errors[name] = result.violations
          end
        }
      end

    end # Validator
  end # Handler
end # Subway
