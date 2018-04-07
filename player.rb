class Player
  attr_accessor :x, :y, :vel

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

  def up(options = {}); move(0, options); end
  def down(options = {}); move(1, options); end
  def left(options = {}); move(2, options); end
  def right(options = {}); move(3, options); end

  def move(direction, options)
    case direction
    when 0
      @pos = 36
      @y -= @vel unless options[:stand_still]
    when 1
      @pos = 0
      @y += @vel unless options[:stand_still]
    when 2
      @pos = 12
      @x -= @vel unless options[:stand_still]
    when 3
      @pos = 24
      @x += @vel unless options[:stand_still]
    end 
    @anim = Gosu::milliseconds / 100 % 3
  end

  def draw
    @poses[@pos + @anim].draw(@x, @y, 1)
  end
end
