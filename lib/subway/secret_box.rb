# encoding: utf-8

module Subway

  # Provides authenticated secret-key encryption
  class SecretBox

    def self.key_bytes
      RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    end

    def initialize(secret_key)
      @box = RbNaCl::RandomNonceBox.from_secret_key(secret_key)
    end

    def encrypt(text)
      @box.encrypt(text)
    end

    def decrypt(text)
      @box.decrypt(text)
    end

  end # class SecretBox
end # module Subway
