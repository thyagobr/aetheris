class Player
  attr_reader :x, :y

  def initialize(window)
    @poses = Gosu::Image.load_tiles(window, Utils.image_path_for("crisiscorepeeps"), 32, 32, true)
    @x = @y = 0
    @vel = 3
    @pos = 0
    @anim = 0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def pos_x; @x + 32; end
  def pos_y; @y + 32; end

  def up; move(0); end
  def down; move(1); end
  def left; move(2); end
  def right; move(3); end

  def move(direction)
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
    @poses[@pos + @anim].draw(@x, @y, 1)
  end
end
