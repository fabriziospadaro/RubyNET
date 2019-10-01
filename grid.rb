class Grid
  attr_accessor :grid
  attr_reader :height, :width

  def initialize(height, width, block_size = 64)
    @grid = Array.new(height) {Array.new(width)}
    @height = height
    @width = width
    @block_size = block_size
    draw
  end

  def draw
    @grid.each_with_index do |v1, y|
      v1.each_index do |x|
        @square = Square.new(x: x * @block_size, y: y * @block_size, size: @block_size, color: 'random')
      end
    end
  end
end
