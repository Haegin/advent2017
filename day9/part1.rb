#!/usr/bin/env ruby

require "treetop"

Treetop.load "stream"

class Cleaner
  CANCELLED = /!./.freeze
  GARBAGE = /<.*?>/.freeze

  def initialize(dirty)
    @dirty = dirty
  end

  def clean
    @clean ||= @dirty.gsub(CANCELLED, '').gsub(GARBAGE, '')
  end
end

input = File.read('./input')
clean = Cleaner.new(input).clean
parser = StreamParser.new
puts parser.parse(clean).total_score
