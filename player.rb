class Player
  attr_accessor :x, :y, :vel, :invisible

  def initialize(window)
    @poses = Gosu::Image.load_tiles(window, Utils.image_path_for("crisiscorepeeps"), 32, 32, true)
    @x = @y = 0
    @vel = 3
    @pos = 0
    @anim = 0
    @score = 0
    @invisible = false
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
      future_position = CollisionBox.new(@x, @y - @vel, pos_x, pos_y - @vel)
      space_is_occupied = Screen::PROPS.any? do |prop|
        future_position.collided_with(prop) 
      end

      unless space_is_occupied
        @pos = 36
        @y -= @vel unless options[:stand_still]
      end
    when 1
      future_position = CollisionBox.new(@x, @y + @vel, pos_x, pos_y + @vel)
      space_is_occupied = Screen::PROPS.any? do |prop|
        future_position.collided_with(prop) 
      end

      unless space_is_occupied
        @pos = 0
        @y += @vel unless options[:stand_still]
      end
    when 2
      future_position = CollisionBox.new(@x - @vel, @y, pos_x - @vel, pos_y)
      space_is_occupied = Screen::PROPS.any? do |prop|
        future_position.collided_with(prop) 
      end

      unless space_is_occupied
        @pos = 12
        @x -= @vel unless options[:stand_still]
      end
    when 3
      future_position = CollisionBox.new(@x + @vel, @y, pos_x + @vel, pos_y)
      space_is_occupied = Screen::PROPS.any? do |prop|
        future_position.collided_with(prop) 
      end

      unless space_is_occupied
        @pos = 24
        @x += @vel unless options[:stand_still]
      end
    end 
    @anim = Gosu::milliseconds / 100 % 3
  end

  def draw
    transparency_mode = is_visible? ? 0xff_ffffff : 0x33_ffffff
    @poses[@pos + @anim].draw(@x, @y, 1, 2, 2, transparency_mode)
  end

  private

  def is_visible?
    !@invisible ||= false
  end
end
