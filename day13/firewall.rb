#!/usr/bin/env ruby

require "set"
require "minitest/autorun"

class Firewall
  attr_reader :layers

  def initialize(input)
    @layers = Hash[input.chomp.split("\n").map do |line|
      line.split(": ").map(&:to_i)
    end]
  end

  def is_caught(delay)
    (0..layers.keys.max).none? do |layer|
      layers[layer] && (layer + delay) % ((layers[layer] * 2) - 2) == 0
    end
  end

  def caught(delay = 0)
    (0..layers.keys.max).select do |layer|
      layers[layer] && (layer + delay) % ((layers[layer] * 2) - 2) == 0
    end
  end

  def trip_severity(delay = 0)
    caught(delay).map { |depth| depth * layers[depth] }.sum
  end
end

test_input = <<-END
0: 3
1: 2
4: 4
6: 4
END

describe Firewall do
  it "knows when it's been caught" do
    firewall = Firewall.new(test_input)
    expect(firewall.caught).must_equal([0, 6])
  end

  it "knows how bad it is to be caught" do
    firewall = Firewall.new(test_input)
    expect(firewall.trip_severity).must_equal(24)
  end

  it "can delay packets" do
    firewall = Firewall.new(test_input)
    expect(firewall.trip_severity(10)).must_equal(0)
  end
end

puts "~~~ Part 1 ~~~"

firewall = Firewall.new(File.read('./input'))
puts "Solution: #{firewall.trip_severity}"
puts

puts "~~~ Part 2 ~~~"

delay = 0
loop do
  break if firewall.is_caught(delay)
  delay += 1
end

puts "Solution: #{delay}"
