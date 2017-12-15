#!/usr/bin/env ruby

require "minitest/autorun"

class Cleaner
  CANCELLED = /!./.freeze
  GARBAGE = /(<.*?>)/.freeze

  def initialize(dirty)
    @dirty = dirty
  end

  def without_cancelled
    @without_cancelled ||= @dirty.gsub(CANCELLED, '')
  end

  def garbage_chars
    without_cancelled.split(GARBAGE)
      .select { |str| str =~ GARBAGE }
      .map { |str| str.length - 2 }
      .sum
  end
end

describe Cleaner do
  it "must count the garbage correctly" do
    expect(Cleaner.new("<random characters>").garbage_chars).must_equal 17
    expect(Cleaner.new("<>").garbage_chars).must_equal 0
    expect(Cleaner.new("<<<<>").garbage_chars).must_equal 3
    expect(Cleaner.new("<{!>}>").garbage_chars).must_equal 2
    expect(Cleaner.new("<!!>").garbage_chars).must_equal 0
    expect(Cleaner.new("<!!!>>").garbage_chars).must_equal 0
    expect(Cleaner.new("<{o\"i!a,<{i<a>").garbage_chars).must_equal 10
  end
end

input = File.read('./input')
solution = Cleaner.new(input).garbage_chars
puts "Solution: #{solution}"
puts
