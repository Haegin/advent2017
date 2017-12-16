#!/usr/bin/env ruby

require "set"
require "minitest/autorun"

class Pipes
  attr_reader :process_map

  def initialize(input)
    @process_map ||= Hash[input.chomp.split("\n").map do |line|
      process, connected = line.split(" <-> ")
      [process.to_i, connected.split(", ").map(&:to_i)]
    end]
  end

  def number_of_groups
    groups = []
    process_map.each do |process, _|
      next if groups.any? { |g| g.include? process }
      groups << group(process)
    end
    groups.count
  end

  def group(process)
    gather_list = [process]
    group = Set.new()
    until gather_list.empty?
      process = gather_list.pop()
      next if group.include? process
      group.add process
      gather_list.concat process_map[process]
    end
    group
  end
end

test_input = <<-END
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
END

describe Pipes do
  it "groups processes correctly" do
    pipes = Pipes.new(test_input)
    expect(pipes.group(0).to_a.sort).must_equal [0, 2, 3, 4, 5, 6]
  end

  it "counts groups correctly" do
    pipes = Pipes.new(test_input)
    expect(pipes.number_of_groups).must_equal 2
  end
end

puts "~~~ Part 1 ~~~"

pipes = Pipes.new(File.read('./input'))
puts "Solution: #{pipes.group(0).size}"
puts

puts "~~~ Part 2 ~~~"
puts "Solution: #{pipes.number_of_groups}"
