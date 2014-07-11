# encoding: utf-8

require 'concord'
require 'adamantium'
require 'bcrypt'

module Subway

  # Provides password encryption using bcrypt
  class Password

    class Generator

      include Concord.new(:plaintext)

      def self.call(plaintext)
        new(default_password(plaintext)).call
      end

      def self.default_password?(plaintext, initial_default)
        plaintext == default_password(initial_default)
      end

      def self.default_password(plaintext)
        Digest::MD5.hexdigest(plaintext).chars.to_a[4..13].join(EMPTY_STRING)
      end

      def call
        Password.create(plaintext)
      end

    end # Generator

    include Concord.new(:bcrypt_password)
    include Adamantium

    DEFAULT_COST = 10

    def self.create(plaintext, cost = DEFAULT_COST)
      new(BCrypt::Password.create(plaintext, :cost => cost))
    end

    def self.coerce(ciphertext)
      new(BCrypt::Password.new(ciphertext))
    end

    def self.match?(plaintext, ciphertext)
      coerce(ciphertext).match?(plaintext)
    rescue BCrypt::Errors::InvalidHash
      false
    end

    def match?(password)
      @bcrypt_password == password
    end

    def to_s
      @bcrypt_password.to_s
    end

  end # class Password
end # module Subway
