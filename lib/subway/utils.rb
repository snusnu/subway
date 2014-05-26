module Subway
  module Utils

    extend self

    def require_pattern(root, pattern)
      Dir[root.join(pattern)].sort.each { |file| require file }
    end

  end # module Utils
end # module Subway
