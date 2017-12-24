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
    translating_to = Screen::WIDTH + (@x - 3).abs
    @x -= 3 if translating_to <= @total_level_width * Screen::TILE_SIZE
  end

  def move_up
    @y += 3
    @y = 0 if @y > 0
  end

  def move_down
    translating_to = Screen::HEIGHT + (@y - 3).abs
    @y -= 3 if translating_to <= @total_level_height * Screen::TILE_SIZE
  end

  def is_touching_edge?(side)
    case side
    when :top
      return @y == 0
    when :left
      return @x == 0
    when :bottom
      # this reducing is because the numbers aren't matching exactly: they differ by a fex pixels
      return (@total_level_height * Screen::TILE_SIZE) - (Screen::HEIGHT + @y.abs) <= 2
    when :right
      # this reducing is because the numbers aren't matching exactly: they differ by a fex pixels
      return (@total_level_width * Screen::TILE_SIZE) - (Screen::WIDTH + @x.abs) <= 2
    end
  end
end
