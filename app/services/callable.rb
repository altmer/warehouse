# frozen_string_literal: true

module Callable
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  class Outcome
    attr_reader :result, :error

    def initialize(result: nil, error: nil)
      @result = result
      @error = error
    end

    def success?
      @error.nil?
    end

    def failure?
      !success?
    end
  end

  def call
    raise NotImplementedError
  end

  module ClassMethods
    def call(*args)
      Outcome.new(result: new(*args).call)
    rescue StandardError => e
      Outcome.new(error: e.message)
    end
  end
end
