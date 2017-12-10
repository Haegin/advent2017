#!/usr/bin/env ruby

require "treetop"

Treetop.load "instructions"

class Computer
  attr_reader :instructions, :ic, :registers
  def initialize(instructions)
    @instructions = instructions
    @ic = 0
    @registers = Hash.new(0)
  end

  def run
    while @ic < instructions.length
      parser.parse(instructions[ic]).call(@registers)
      @ic += 1
    end
  end

  def largest_register
    registers.reduce do |(max_name, max_value), (name, value)|
      if value > max_value
        [name, value]
      else
        [max_name, max_value]
      end
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
puts(computer.largest_register)
