class Point
  attr_accessor :x, :y

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def set(x, y)
    @x = x
    @y = y
  end

  def ==(b)
    (@x == b.x && @y == b.y)
  end

  def -(b)
    Point.new(@x - b.x, @y - b.y)
  end

  def +(b)
    Point.new(@x + b.x, @y + b.y)
  end

  def self.zero
    Point.new(0, 0)
  end

  def to_s
    "x: #{@x}, y: #{@y} "
  end

end
