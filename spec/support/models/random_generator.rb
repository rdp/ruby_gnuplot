# frozen_string_literal: true

class RandomGenerator
  KAPA = 3.95578

  class << self
    def rand
      @rand ||= Random.rand

      @rand = KAPA * @rand * (1 - @rand)
    end

    def seed(value)
      @rand = value.abs % 1
      @rand = nil if @rand == 0
    end
  end
end
