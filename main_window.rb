require 'rubygems'
require 'gosu'
require 'pry'

class Screen < Gosu::Window

  def initialize
    @width = 800
    @height = 640
    super(@width, @height, fullscreen = false)
    self.caption = "Aetheris"
    @level = Array.new((@width / 32) * (@height / 32), [0, 1]).flatten
    @floor1 = Gosu::Image.new(self, "castlefloors.png", true, 0, 0, 32, 32)
    @floor2 = Gosu::Image.new(self, "castlefloors.png", true, 32 * 4, 0, 32, 32)
    @spell = Gosu::Image.new(self, "explosion.png", true, 0, 0, 32 * 3, 32 * 3)
    @spell_cooldown = 0
    @game_name = Gosu::Image.from_text(self, "Aetheris", Gosu.default_font_name, 100)
    @player = Player.new(self)
    @player.warp(300, 200)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.up
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      @player.down
    end
    if button_down? Gosu::MsLeft then
      puts "it is such a disgrace!"
      if @spell_cooldown == 0
        puts "couldn't watch your back today"
        @spell_cooldown = Gosu::milliseconds
        @spell_x = mouse_x 
        @spell_y = mouse_y
      end
    end
    @spell_cooldown = 0 if (Gosu::milliseconds - @spell_cooldown) >= 3000

    if @spell_x and @spell_y
      box1 = Box.new(@player.x, @player.y, @player.pos_x, @player.pos_y)
      # @spell_x and @spell_y aren't the left/top of the box
      # we capture the click and render these variables *as the center point*
      # so, we have to calculate the left/top
      box2 = Box.new((@spell_x - (@spell.width / 2)), (@spell_y - (@spell.width / 2)), (@spell_x + (@spell.width / 2)), (@spell_y + (@spell.height / 2)))
      collided = box1.collided_with(box2)
      puts "player left: #{box1.left}, top: #{box1.top}, right: #{box1.right}, bottom #{box1.bottom}"
      puts "spell left: #{box2.left}, top: #{box2.top}, right: #{box2.right}, bottom #{box2.bottom}"
      puts "#{Gosu::milliseconds} COLLIDED!" if collided
      #collide = Gosu::distance(@player.pos_x, @player.pos_y, @spell_x, @spell_y)
      #if (collide <= 48) then
      #  puts "[#{Time.now} collision!"
      #else
      #  puts "[#{Time.now}] #{collide}"
      #end
    end
  end

  def draw
    pitch = @width / 32

    (@height / 32).times do |h|
      (@width / 32).times do |w|
        case @level[w + h * pitch]
        when 0
          @floor1.draw(32 * w, 32 * h, 0)
        when 1
          @floor2.draw(32 * w, 32 * h, 0)
        when 2
          @floor2.draw(32 * w, 32 * h, 0, 1, 1, 0xFFFF0000)
        end
      end
    end

    @player.draw

    if @spell_x and @spell_y then
      @mod = Gosu::milliseconds unless @mod
      fade_out = ((Gosu::milliseconds - @mod) / 5) % 0xFF
      if fade_out >= 252
        @spell_x, @spell_y, @mod = nil
      else
        alpha = 0xFF - fade_out
        @spell.draw(@spell_x - (@spell.width / 2), @spell_y - (@spell.height / 2), 1, 1, 1, Gosu::Color.new(alpha, 255, 255, 255))
      end
    end
  end

  def needs_cursor?; true; end
end

class Player
  attr_reader :x, :y

  def initialize(window)
    @poses = Gosu::Image.load_tiles(window, "crisiscorepeeps.png", 32, 32, true)
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

class Box
  attr_accessor :top, :left, :bottom, :right

  def initialize(left,top, right, bottom)
    self.left = left
    self.top = top
    self.right = right
    self.bottom = bottom
  end

  def collided_with(other_box)
   return !(self.right <= other_box.left or
     self.left >= other_box.right or
     self.bottom <= other_box.top or
     self.top >= other_box.bottom)   # kkkkkkkkkkkkkkkk
  end

end

Screen.new.show
