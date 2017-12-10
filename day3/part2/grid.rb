class Grid
  def initialize
    @grid = Hash.new do |h, k|
      h[k] = Hash.new(0)
    end
  end

  def insert(x, y, value)
    @grid[x][y] = value
  end

  def get(x, y)
    @grid[x][y]
  end

  def print
    min_x = @grid.keys.min
    min_y = @grid.map { |_, vs| vs.keys.min }.compact.min
    max_x = @grid.keys.max
    max_y = @grid.map { |_, vs| vs.keys.max }.compact.max
    (min_y..max_y).map { |y|
      (min_x..max_x).map { |x|
        get(x, y)
      }
    }.reverse
  end
end
