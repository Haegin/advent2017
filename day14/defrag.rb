#!/usr/bin/env ruby

require "./knot_hash"
require "minitest/autorun"

SIZE = 128

class Defrag
  attr_reader :key

  def initialize(key)
    @key = key
  end

  def regions
    regions = []
    cells = (0...SIZE).to_a.product((0...SIZE).to_a)
    until cells.empty?
      cell = cells.pop
      next unless get(*cell) == 1
      region = find_region(cell)
      cells -= region
      regions << region
    end
    regions
  end

  def used_space
    binary.map { |row| row.count(1) }.sum
  end

  def free_space
    (SIZE * SIZE) - used_space
  end

  def to_s
    binary.map { |x| x.join('') }.join("\n")
  end

  private

  def find_region(cell)
    search_list = [cell]
    in_region = []
    until search_list.empty?
      current = search_list.pop
      in_region << current
      adjacent = adjacency_grid.adjacent(*current)
      adjacent -= in_region
      search_list.concat(adjacent)
    end
    in_region
  end

  def get(x, y)
    binary[y][x]
  end

  def hashes
    (0...SIZE).map do |row|
      KnotHash.new(256).hash("#{key}-#{row}")
    end
  end

  def binary
    @binary ||= hashes.map do |row|
      row.split("").flat_map do |letter|
        letter.to_i(16).to_s(2).rjust(4, "0").split("").flat_map(&:to_i)
      end
    end
  end

  def adjacency_grid
    @adjacency_grid ||= AdjacencyGrid.new(binary)
  end
end

class AdjacencyGrid
  def initialize(contents)
    @contents = contents
  end

  def adjacent(x, y)
    [
      [x, y - 1], [x, y + 1],
      [x - 1, y], [x + 1, y],
    ].
      reject { |x1, y1| x1 < 0 || y1 < 0 }.
      reject { |x1, y1| x1 >= @contents.length || y1 >= @contents.length }.
      select { |x1, y1| get(x1, y1) == 1 }
  end

  def get(x, y)
    @contents[y][x]
  end
end

describe AdjacencyGrid do
  before do
    @grid = AdjacencyGrid.new([
      [1, 0, 1, 0],
      [0, 0, 1, 1],
      [0, 1, 1, 0],
      [0, 0, 0, 0],
      [0, 1, 1, 0],
    ])
  end

  it "knows which cells are adjacent" do
    expect(@grid.adjacent(0, 0)).must_equal([])
    expect(@grid.adjacent(1, 4)).must_equal([[2, 4]])
    expect(@grid.adjacent(2, 1).sort).must_equal([
      [2, 0], [3, 1], [2, 2]
    ].sort)
  end
end

class RegionCounter
  def initialize
    @regions = []
  end

  def count
    @regions.length
  end

  def insert(cells)
    existing_region = @regions.select { |region| region.include? cells.first }
    if existing_region
      existing_region.concat(cells)
    else
      @regions.push(Set.new(cells))
    end
  end
end

describe Defrag do
  it "knows how much space is used" do
    defrag = Defrag.new("flqrgnkx")
    expect(defrag.used_space).must_equal 8108
  end

  it "can count regions" do
    defrag = Defrag.new("flqrgnkx")
    expect(defrag.regions.count).must_equal 1242
  end
end

puts "~~~ Part 1 ~~~"

input = "ffayrhll"
defrag = Defrag.new(input)
solution = defrag.used_space

puts "Solution: #{solution}"
puts

puts "~~~ Part 2 ~~~"

solution = defrag.regions.count

puts "Solution: #{solution}"
