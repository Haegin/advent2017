#!/usr/bin/env ruby

require "minitest/autorun"

class Generator
  attr_reader :current, :factor

  DIVISOR = 2147483647

  def initialize(start, factor)
    @current = start
    @factor = factor
  end

  def step
    @current = (current * factor) % DIVISOR
  end

  def to_binary
    current.to_s(2).rjust(32, "0")
  end
end

describe Generator do
  it "can generate values correctly" do
    generator = Generator.new(65, 16807)
    expect(5.times.map { generator.step }).must_equal([
      1092455, 1181022009, 245556042, 1744312007, 1352636452,
    ])
  end

  it "can generate values when the generator is picky" do
    generator = Generator.new(65, 16807, proc { |n| n % 4 == 0 })
    expect(5.times.map { generator.step }).must_equal([
      1352636452, 1992081072, 530830436, 1980017072, 740335192,
    ])
  end

  it "can represent a value as binary" do
    generator = Generator.new(65, 16807)
    expect(5.times.map { generator.step; generator.to_binary }).must_equal([
      "00000000000100001010101101100111",
      "01000110011001001111011100111001",
      "00001110101000101110001101001010",
      "01100111111110000001011011000111",
      "01010000100111111001100000100100",
    ])
  end
end

class Judge
  attr_reader :gen_a, :gen_b, :same

  def initialize(gen_a, gen_b)
    @gen_a = gen_a
    @gen_b = gen_b
    @same = 0
  end

  def rounds(number)
    number.times { |n| round }
    same
  end

  private

  def round
    @same += 1 if (gen_a.step % 65536) == (gen_b.step % 65536)
  end
end

describe Judge do
  it "can compare values" do
    gen_a = Generator.new(65, 16807)
    gen_b = Generator.new(8921, 48271)
    judge = Judge.new(gen_a, gen_b)
    expect(judge.rounds(5)).must_equal(1)

    if ENV["ALL_TESTS"]
      expect(judge.rounds(40_000_000 - 5)).must_equal(588)
    end
  end
end

gen_a = Generator.new(722, 16807)
gen_b = Generator.new(354, 48271)
judge = Judge.new(gen_a, gen_b)
judge.rounds(40_000_000)

puts "~~~ Part 1. ~~~"
puts "Solution: #{judge.same}"
