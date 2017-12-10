class Puzzle
  attr_reader :grid, :target

  def initialize(target)
    @target = target
    @grid = Hash.new do |h, k|
      h[k] = Hash.new(0)
    end
    insert(0, 0, 1)
  end

  def solve
    ring = 1
    loop do
      numbs = (
        (-ring+1..ring).map { |y| [ring, y] } +
        (-ring..ring).map { |x| [x, ring] }.reverse +
        (-ring..ring).map { |y| [-ring, y] }.reverse +
        (-ring..ring).map { |x| [x, -ring] } +
        [[ring, -ring]]
      ).uniq
      numbs.each do |(x, y)|
        next_number = calculate(x, y)
        insert(x, y, next_number)
        if next_number > target
          return next_number
        end
      end
      ring += 1
    end
  end

  private

  def calculate(x, y)
    xs = [x - 1, x, x + 1]
    ys = [y - 1, y, y + 1]
    xs.product(ys).map { |(x_1, y_1)| get(x_1, y_1) }.sum
  end

  def insert(x, y, value)
    @grid[x][y] = value
  end

  def get(x, y)
    @grid[x][y]
  end
end

puzzle = Puzzle.new(368078)
puts puzzle.solve
