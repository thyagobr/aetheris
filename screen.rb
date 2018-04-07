class Screen < Gosu::Window
  WIDTH = 800
  HEIGHT = 640
  MAP_WIDTH = 1008 * 2
  MAP_HEIGHT = 689 * 2
  TILE_SIZE = 32
  PROPS = [CollisionBox.new(0, 0, 55, 140)]

  def initialize
    @width = 800
    @width_tiles = @width / 32
    @height = 640
    @height_tiles = @height / 32
    super(@width, @height, fullscreen = false)
    self.caption = "Aetheris"

    @new_level = Array.new(@height_tiles, Array.new(@width_tiles + 1, 0))
    @new_level << Array.new(@width_tiles + 1, 2)

    @spell = Gosu::Image.new(Utils.image_path_for("explosion"), rect: [0, 0, 32 * 3, 32 * 3])
    @spell_cooldown = 0
    @game_name = Gosu::Image.from_text("Aetheris", 100)
    @player = Player.new(self)
    @player.warp(300, 200)
    @visibility = { fog: 3 }
    @map = Gosu::Image.new("images/map.jpg")
    @camera = Camera.new(x: 0, y: 0, width: @new_level[0].count, height: @new_level.count)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @byebug = !@byebug if id == Gosu::KbP
  end

  def update
    handle_input

    @spell_cooldown = 0 if (Gosu::milliseconds - @spell_cooldown) >= 3000

    if @spell_x and @spell_y
      box1 = CollisionBox.new(@player.x, @player.y, @player.pos_x, @player.pos_y)
      box2 = CollisionBox.new((@spell_x - (@spell.width / 2)), (@spell_y - (@spell.width / 2)), (@spell_x + (@spell.width / 2)), (@spell_y + (@spell.height / 2)))
      collided = box1.collided_with(box2)
    end
  end

  def draw
    @map.draw(@camera.x, @camera.y, 0, 2, 2)

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

  private

  def handle_input
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      mid_of_screen = Screen::WIDTH / 2
      if @camera.is_touching_edge?(:left)
        player_hit_edge = @player.x - @player.vel <= 0
        @player.left(stand_still: player_hit_edge)
      else
        if @player.x > mid_of_screen
          @player.left
        else
          @camera.move_left 
          @player.left(stand_still: true)
        end
      end
    end

    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      mid_of_screen = Screen::WIDTH / 2

      if @player.x < mid_of_screen || @camera.is_touching_edge?(:right)
        camera_hit_edge_but_player_didnt = @player.x <= Screen::WIDTH - Screen::TILE_SIZE
        @player.right if camera_hit_edge_but_player_didnt
      else
        @camera.move_right
        # make the player pretend it is moving, otherwise it slides on screen
        @player.right(stand_still: true)
      end
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      mid_of_screen = Screen::HEIGHT / 2
      if @camera.is_touching_edge?(:top)
        player_hit_edge = @player.y - @player.vel <= 0
        @player.up(stand_still: player_hit_edge)
      else
        if @player.y > mid_of_screen
          @player.up
        else
          @camera.move_up
          @player.up(stand_still: true)
        end
      end
    end

    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      mid_of_screen = Screen::HEIGHT / 2
      if @player.y < mid_of_screen || @camera.is_touching_edge?(:bottom)
        camera_hit_edge_but_player_didnt = @player.y <= Screen::HEIGHT - Screen::TILE_SIZE
        @player.down if camera_hit_edge_but_player_didnt
      else
        @camera.move_down
        @player.down(stand_still: true)
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
  end
end
