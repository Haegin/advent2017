#!/usr/bin/env ruby

require "minitest/autorun"

class KnotHash
  attr_reader :ring

  SUFFIX = [17, 31, 73, 47, 23]
  ROUNDS = 64

  def initialize(ring_size)
    @ring = (0...ring_size).to_a
    @position = 0
    @skip_size = 0
  end

  def hash(input)
    calculate_sparse_hash(input)
    to_hex
  end

  def calculate_sparse_hash(input)
    lengths = input.split('').map(&:ord).concat(SUFFIX)
    ROUNDS.times do
      round(lengths)
    end
  end

  def dense_hash
    @ring.each_slice(16).map { |block| block.reduce(:^) }
  end

  def to_hex
    dense_hash.map { |x| x.to_s(16).rjust(2, '0') }.join
  end

  def round(lengths)
    lengths.each do |length|
      twist(length)
    end
    ring
  end

  private

  def twist(length)
    raise "Invalid length" if length > @ring.length
    reverse(@position, length)
    @position = (@position + length + @skip_size) % 256
    @skip_size += 1
  end

  def reverse(start, length)
    sublist = @ring.rotate!(start).shift(length)
    @ring = sublist.reverse.concat(@ring).rotate(-start)
  end
end

describe KnotHash do
  it "performs the example round correctly" do
    result = KnotHash.new(5).round([3, 4, 1, 5])
    expect(result).must_equal [3, 4, 2, 1, 0]
    expect(result[0] * result[1]).must_equal 12
  end

  it "can hash strings" do
    expect(KnotHash.new(256).hash("")).must_equal "a2582a3a0e66e6e86e3812dcb672a272"
    expect(KnotHash.new(256).hash("AoC 2017")).must_equal "33efeb34ea91902bb2f59c9920caa6cd"
    expect(KnotHash.new(256).hash("1,2,3")).must_equal "3efbe78a8d82f29979031a4aa0b16a9d"
  end
end

puts "~~~ Part 1 ~~~"

input = [102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216]
solution = KnotHash.new(256).round(input)

puts "Solution: #{solution[0] * solution[1]}"
puts

puts "~~~ Part 2 ~~~"

input = '102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216'
solution = KnotHash.new(256).hash(input)

puts "Solution: #{solution}"
puts
