require './src/utils'
require './src/weapon'

class Player
  attr_accessor :x, :y, :max_movement, :weapon

  def initialize(window)
    @poses = Gosu::Image.load_tiles(window, Utils.image_path_for("crisiscorepeeps"), 32, 32, true)
    @x = @y = 0
    @pos = 0
    @anim = 0
    @invisible = false
    @max_movement = 6
    @weapon = Weapon.new(range: 3, base_dice: 10)
  end

  def warp(x, y)
    @x, @y = x, y
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
