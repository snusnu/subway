module Subway
  module Utils

    def self.require_pattern(root, pattern)
      Dir[root.join(pattern)].each { |file| require file }
    end

    module Anima
      def to_h
        self.class.attributes_hash(self)
      end
    end # module Anima

  end # module Utils
end # module Subway
