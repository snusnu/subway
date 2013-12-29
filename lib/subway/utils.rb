module Subway
  module Utils

    def self.require_pattern(root, pattern)
      Dir[root.join(pattern)].sort.each { |file| require file }
    end

  end # module Utils
end # module Subway
