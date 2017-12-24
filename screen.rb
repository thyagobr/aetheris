class Screen < Gosu::Window
  WIDTH = 800
  HEIGHT = 640
  TILE_SIZE = 32

  def initialize
    @width = 800
    @width_tiles = @width / 32
    @height = 640
    @height_tiles = @height / 32
    super(@width, @height, fullscreen = false)
    self.caption = "Aetheris"

    @new_level = Array.new(@height_tiles, Array.new(@width_tiles + 1, 0))
    @new_level << Array.new(@width_tiles + 1, 2)

    @floor1 = Gosu::Image.new(self, Utils.image_path_for("castlefloors"), true, 0, 0, 32, 32)
    @floor2 = Gosu::Image.new(self, Utils.image_path_for("castlefloors"), true, 32 * 4, 0, 32, 32)
    @floor4 = Gosu::Image.new(self, Utils.image_path_for("castlefloors"), true, 32 * 9, 0, 32 * 4, 32)
    @spell = Gosu::Image.new(self, Utils.image_path_for("explosion"), true, 0, 0, 32 * 3, 32 * 3)
    @spell_cooldown = 0
    @game_name = Gosu::Image.from_text(self, "Aetheris", Gosu.default_font_name, 100)
    @player = Player.new(self)
    @player.warp(300, 200)
    @visibility = { fog: 3 }
    @camera = Camera.new(x: 0, y: 0, width: @new_level[0].count, height: @new_level.count)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @byebug = !@byebug if id == Gosu::KbP
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @camera.move_left
      @player.left if @player.x >= 0 && @camera.is_touching_edge?(:left)
    end

    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      mid_of_screen = (Screen::WIDTH + @camera.x.abs) / 2
      if @player.x < mid_of_screen || @camera.is_touching_edge?(:right)
        @player.right if @player.x <= @width - 32
      else
        @camera.move_right
      end
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @camera.move_up
      @player.up if @player.y >= 0 && @camera.is_touching_edge?(:top)
    end

    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      mid_of_screen = (Screen::HEIGHT + @camera.y.abs) / 2
      if @player.y < mid_of_screen || @camera.is_touching_edge?(:bottom)
        @player.down if @player.y <= @height - 32
      else
        @camera.move_down
      end
    end

    if button_down? Gosu::MsLeft then
      puts "Player x,y: #{@player.x},#{@player.y}"
      if @spell_cooldown == 0
        @spell_cooldown = Gosu::milliseconds
        @spell_x = mouse_x 
        @spell_y = mouse_y
      end
    end
    @spell_cooldown = 0 if (Gosu::milliseconds - @spell_cooldown) >= 3000

    if @spell_x and @spell_y
      box1 = CollisionBox.new(@player.x, @player.y, @player.pos_x, @player.pos_y)
      box2 = CollisionBox.new((@spell_x - (@spell.width / 2)), (@spell_y - (@spell.width / 2)), (@spell_x + (@spell.width / 2)), (@spell_y + (@spell.height / 2)))
      collided = box1.collided_with(box2)
    end
  end

  def draw
    translate(@camera.x, @camera.y) do
      @new_level.each.with_index do |row, h|
        row.each.with_index do |tile, w|
          case tile
          when 0
            @floor1.draw(32 * w, 32 * h, 0)
          when 2
            @floor4.draw(32 * w, 32 * h, 0)
          end
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
