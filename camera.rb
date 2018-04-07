class Camera
  attr_accessor :x, :y

  def initialize(args)
    @x = args[:x]
    @y = args[:y]
    @total_level_width = args[:width]
    @total_level_height = args[:height]
  end

  def move_left
    @x += 3
    @x = 0 if @x > 0
  end

  def move_right
    @x -= 3
  end

  def move_up
    @y += 3
    @y = 0 if @y > 0
  end

  def move_down
    @y -= 3
  end

  # is the camera touching the edge of the map?
  # that is: we should stop here.
  def is_touching_edge?(side)
    case side
    when :top
      return @y == 0
    when :left
      return @x == 0
    when :bottom
      return @y.abs >= Screen::MAP_HEIGHT - Screen::HEIGHT
    when :right
      return @x.abs >= Screen::MAP_WIDTH - Screen::WIDTH
    end
  end
end
