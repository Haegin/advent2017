require 'grid'

class Puzzle
  attr_reader :grid, :target, :ring

  def initialize(target)
    @target = target
    @grid = Grid.new
    @grid.insert(0, 0, 1)
    @ring = 1
  end

  def calculate(x, y)
    xs = [x - 1, x, x + 1]
    ys = [y - 1, y, y + 1]
    xs.product(ys).map { |(x_1, y_1)| grid.get(x_1, y_1) }.sum
  end

  def loop
    numbs = (
      (-ring+1..ring).map { |y| [ring, y] } +
      (-ring..ring).map { |x| [x, ring] }.reverse +
      (-ring..ring).map { |y| [-ring, y] }.reverse +
      (-ring..ring).map { |x| [x, -ring] } +
      [[ring, -ring]]
    ).uniq
    numbs.each do |(x, y)|
      next_number = calculate(x, y)
      grid.insert(x, y, next_number)
      if next_number > target
        puts next_number
        raise
      end
    end
    @ring += 1
  end

  def print
    grid.print.map do |line|
      puts line.map { |n| n.to_s.ljust(8) }.join()
    end
  end
end
