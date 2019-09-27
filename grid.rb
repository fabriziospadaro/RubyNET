require 'pry'
class Grid
  attr_accessor :grid
  attr_reader :height, :width

  def initialize(height, width, placeholder)
    @grid = Array.new(height) {Array.new(width, placeholder)}
    @height = height
    @width = width
    @placeholder = placeholder
  end

  def set(point, value)
    @grid[point.y][point.x] = value
  end

  def clean
    @grid.each_with_index do |v1, y|
      v1.each_index do |x|
        @grid[y][x] = @placeholder
      end
    end
  end

  def draw
    system 'clear'

    @grid.map do |cell|
      puts cell.join(' ') + "\r"
      $stdout.flush
    end
  end

  private

end
