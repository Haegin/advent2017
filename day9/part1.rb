#!/usr/bin/env ruby

require "pry"
require "treetop"

Treetop.load "stream"

class Cleaner
  CANCELLED = /!./.freeze
  GARBAGE = /<.*?>/.freeze

  def initialize(dirty)
    @dirty = dirty
  end

  def clean
    @clean ||= @dirty.gsub(CANCELLED, '').gsub(GARBAGE, '').chomp
  end
end

def score(input)
  clean = Cleaner.new(input).clean
  puts clean
  StreamParser.new.parse(clean).total_score
end

# raise unless score("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
# raise unless score("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
# raise unless score("{{{},{},{{}}}}") == 16

input = File.read('./input')
puts score(input)
