class Screen < Gosu::Window
  WIDTH = 800
  HEIGHT = 640
  MAP_WIDTH = 1008 * 2
  MAP_HEIGHT = 689 * 2
  TILE_SIZE = 32
  PROPS = [CollisionBox.new(0, 0, 55, 140)]

  # todo:
  # * multiplayer
  # * interaction system
  # * inventory
  # * spell ui
  # * dialogue ui
  # * engine-like map editor
  def initialize
    @width = 800
    @width_tiles = @width / 32
    @height = 640
    @height_tiles = @height / 32
    @keys = []
    super(@width, @height, fullscreen = false)
    self.caption = "Aetheris"

    @spell = Gosu::Image.new(Utils.image_path_for("explosion"), rect: [0, 0, 32 * 3, 32 * 3])
    @spell_cooldown = 0
    @game_name = Gosu::Image.from_text("Aetheris", 100)
    @player = Player.new(self)
    @npc = NPC.new
    @player.warp(300, 200)
    @visibility = { fog: 3 }
    @map = Gosu::Image.new("images/map.jpg")
    @camera = Camera.new(x: 0, y: 0, width: WIDTH, height: HEIGHT)
    @interacting = false
    @spell_avalanche_of_fire = nil
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @byebug = !@byebug if id == Gosu::KbP
    register_key_and_check_spell_match(id) if [Gosu::KbU, Gosu::KbI, Gosu::KbO, Gosu::KbP].include?(id)

    # interaction
    if id == Gosu::KbF
      interaction_distance = 50
      player_box = CollisionBox.new(@player.x - interaction_distance, @player.y - interaction_distance, @player.pos_x + interaction_distance, @player.pos_y + interaction_distance)
      npc_box = @npc.collision_box(@camera)
      collided = player_box.collided_with(npc_box)
      if collided
        puts "Hello!"
        @interacting = !@interacting
      else
        @interacting = false
      end
    end

    if id == Gosu::KbT
      @npc.cast(@player)
    end
  end

  def update
    handle_input

    movement_direction

    @spell_cooldown = 0 if (Gosu::milliseconds - @spell_cooldown) >= 3000
  end

  def draw
    @map.draw(@camera.x, @camera.y, 0, 2, 2)

    @player.draw
    # this passing camera guarantees the position is on global scale.
    # since camera is negative as it progresses, the character gets drawn outside of canvas
    @npc.draw(@camera)

    # mimick casting

    if @spell_aof_start_cast
      if (Gosu::milliseconds - @spell_aof_start_cast) > 3000
        puts "BOOM!"
        @spell_aof_start_cast = nil
      end
    end

    if @interacting
      Gosu.draw_rect(16, 400, 800 - 32, 640 - 400 - 16, Gosu::Color.argb(0xbb_000000))
    end

    if @spell_x and @spell_y then
      @mod = Gosu::milliseconds unless @mod
      fade_out = ((Gosu::milliseconds - @mod) / 5) % 0xFF
      if fade_out >= 252
        @spell_x, @spell_y, @mod = nil
      else
        alpha = 0xFF - fade_out
        @spell.draw(@spell_x - (@spell.width / 2), @spell_y - (@spell.height / 2), 1, 2, 2, Gosu::Color.new(alpha, 255, 255, 255))
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
      puts "Camera x,y: #{@camera.x},#{@camera.y}"
    end
  end

  def register_key_and_check_spell_match(key)
    if @keys.count < 2
      if key == Gosu::KbP
        puts "The spell needs three spheres"
      else
        @keys << key
      end
    else
      if key == Gosu::KbP
        # spell: decoy
        if @keys == [Gosu::KbI, Gosu::KbI, Gosu::KbI]
          @player.invisible = true
          # spell: dimensional shift
        elsif @keys == [Gosu::KbO, Gosu::KbO, Gosu::KbO]
          direction = movement_direction
          shift = 120
          x = case direction[0]
              when :left
                @player.x - shift 
              when :right
                @player.x + shift
              else
                @player.x
              end

          y = case direction[1]
              when :up
                @player.y - shift 
              when :down
                @player.y + shift
              else
                @player.y
              end

          @player.x = x
          @player.y = y
        elsif @keys = [Gosu::KbU, Gosu::KbU, Gosu::KbU]
          if @spell_cooldown == 0
            @spell_cooldown = Gosu::milliseconds
            @spell_x = @player.x + 16
            @spell_y = @player.y + 16
          end
        end
      else
        @keys[2] = @keys[1]
        @keys[1] = @keys[0]
        @keys[0] = key
      end
    end

    pp @keys.map { |n| Gosu.button_id_to_char(n) }
  end

  def movement_direction
    x_direction = if button_down? Gosu::KbLeft
                    :left
                  elsif button_down? Gosu::KbRight
                    :right
                  else
                    :still
                  end

    y_direction = if button_down? Gosu::KbUp
                    :up
                  elsif button_down? Gosu::KbDown
                    :down
                  else
                    :still
                  end

    [x_direction, y_direction]
  end
end
