#!/usr/bin/env ruby

require "treetop"

Treetop.load "instructions"

class Computer
  attr_reader :instructions, :ic, :registers, :memory_required

  def initialize(instructions)
    @instructions = instructions
    @ic = 0
    @registers = Hash.new(0)
    @memory_required = [:a, 0]
  end

  def run
    while @ic < instructions.length
      parsed = parser.parse(instructions[ic])
      parsed.call(@registers)
      if (@registers[parsed.modified_register] > @memory_required.last)
        @memory_required = [parsed.modified_register, @registers[parsed.modified_register]]
      end
      @ic += 1
    end
  end

  private

  def parser
    @parser ||= InstructionsParser.new
  end
end

instructions = File.read('./input').each_line.map(&:chomp)

computer = Computer.new(instructions)
computer.run
puts computer.memory_required
