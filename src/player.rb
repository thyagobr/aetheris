require './src/utils'

class Player
  attr_accessor :x, :y, :vel, :invisible, :max_movement

  def initialize(window)
    @poses = Gosu::Image.load_tiles(window, Utils.image_path_for("crisiscorepeeps"), 32, 32, true)
    @x = @y = 0
    @vel = 3
    @pos = 0
    @anim = 0
    @score = 0
    @invisible = false
    @max_movement = 6
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def pos_x; @x + 32; end
  def pos_y; @y + 32; end

  def up(options = {}); move(0, options); end
  def down(options = {}); move(1, options); end
  def left(options = {}); move(2, options); end
  def right(options = {}); move(3, options); end

  def move(direction, options)
    case direction
    when 0
      @pos = 36
      @y -= @vel
    when 1
      @pos = 0
      @y += @vel
    when 2
      @pos = 12
      @x -= @vel
    when 3
      @pos = 24
      @x += @vel
    end
    @anim = Gosu::milliseconds / 100 % 3
  end

  def draw
    transparency_mode = 0xff_ffffff
    @poses[@pos + @anim].draw(@x, @y, 1, 1.5, 1.5, transparency_mode)
  end

  private

  def is_visible?
    !@invisible ||= false
  end
end
