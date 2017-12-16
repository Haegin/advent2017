#!/usr/bin/env ruby

require "minitest/autorun"

class HexGrid
  attr_reader :x, :y, :z, :max_distance

  def initialize
    @x = 0
    @y = 0
    @z = 0
    @max_distance = 0
  end

  def distance
    [x,y,z].map(&:abs).max
  end

  def move(direction)
    case direction
    when :n
      @y += 1
      @z -= 1
    when :ne
      @x += 1
      @z -= 1
    when :se
      @x += 1
      @y -= 1
    when :s
      @y -= 1
      @z += 1
    when :sw
      @x -= 1
      @z += 1
    when :nw
      @x -= 1
      @y += 1
    else
      raise "Not a valid direction: #{direction}"
    end
    @max_distance = distance if distance > max_distance
    return self
  end
end

describe HexGrid do
  it "move 1" do
    grid = HexGrid.new.move(:ne).move(:ne).move(:ne)
    expect(grid.distance).must_equal 3
  end

  it "move 2" do
    grid = HexGrid.new.move(:ne).move(:ne).move(:sw).move(:sw)
    expect(grid.distance).must_equal 0
  end

  it "move 3" do
    grid = HexGrid.new.move(:ne).move(:ne).move(:s).move(:s)
    expect(grid.distance).must_equal 2
  end

  it "move 4" do
    grid = HexGrid.new.move(:se).move(:sw).move(:se).move(:sw).move(:sw)
    expect(grid.distance).must_equal 3
  end
end

grid = HexGrid.new
File.read('./input').chomp.split(',').map(&:to_sym).each do |dir|
  grid.move(dir)
end

puts "~~~ Part 1 ~~~"
puts "Solution: #{grid.distance}"
puts

puts "~~~ Part 2 ~~~"
puts "Solution: #{grid.max_distance}"
