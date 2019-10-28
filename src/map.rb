require 'gosu'
require 'byebug'
require './src/player'

class Map < Gosu::Window
  attr_accessor :tile_position_in_array, :player_moving

  TILE_SIZE = 64
  WIDTH = TILE_SIZE * 20
  HEIGHT = TILE_SIZE * 16
  MAP_WIDTH = WIDTH * 4
  MAP_HEIGHT = HEIGHT * 2

  TILES = [
    0xbb_00aa00, # Green       - standard tile
    0xbb_f0aa00, # Sand yellow - random selection
    0xbb_c00080, # Pink        - selected player
    0xbb_0f5477, # Dark purple - selectable movement 
    0xbb_f70000  # Red         - non-selectable movement
  ]

  # Args may include:
  # - map_file: (file_path) - Load a specific file for map
  def initialize(**args)
    super(WIDTH, HEIGHT, fullscreen = false)
    load_map(args)
    spawn_player
  end

  def needs_cursor?; true; end

  # This method is best used for detecting single keypresses, instead of 
  # continuous one (like mouse drags).
  # This is because this method is called on key_press, not on key_down
  # The method button_down?, however, can be verified on every update of frame
  def button_down(id)
    close if id == Gosu::KbEscape
    save_map if id == Gosu::KbS
    # player movement
    if button_down?(Gosu::KbW)
      if @player_moving
        @map[player_tile_position] = 0 # reset the color of former player selection tile
        @map[@player_last_movement_to] = 0 # reset the color of selectable movement to
        @player.warp(*array_index_to_coords(@player_last_movement_to))
        @player_moving = false
      else
        @player_moving = true if is_player_selected?
      end
    end
  end

  def update
    left_click if button_down?(Gosu::MsLeft) # temp
    handle_input
  end

  def draw
    @player.draw

    draw_current_camera_view
  end

  private

  def load_map(args)
    if args[:map_file]
      puts "Loading file: #{args[:map_file]}"
      @map = load_file(args[:map_file])
    else
      @map = []

      (WIDTH / TILE_SIZE).times do |x|
        (HEIGHT / TILE_SIZE).times do |y|
          @map[x + y * (WIDTH / TILE_SIZE)] = 0
        end
      end
    end
  end

  def spawn_player
    @player = Player.new(self)
    @player_moving = false
  end

  # Tile position is the position in the array number
  def player_tile_position
    player_x = @player.x / TILE_SIZE # position in the array axis
    player_y = @player.y / TILE_SIZE # position in the array axis
    player_x + player_y * (WIDTH / TILE_SIZE)
  end

  def is_player_selected?
    @tile_position_in_array && player_tile_position == @tile_position_in_array
  end

  def left_click
    x = mouse_x.to_i / TILE_SIZE
    y = mouse_y.to_i / TILE_SIZE
    if @player_moving
      player_intended_movement_to = x + y * (WIDTH / TILE_SIZE)
      if not player_intended_movement_to == player_tile_position
        @map[@player_last_movement_to] = 0 if @player_last_movement_to # reset former selection to standard_color
        @player_last_movement_to = player_intended_movement_to # remember where we're selecting
        tile_selection_color = can_player_move_there? ? 3 : 4
        @map[@player_last_movement_to] = tile_selection_color # update the map color to movement_selection
      else
        @map[@player_last_movement_to] = 0 if @player_last_movement_to # reset former selection to standard_color
      end
    else
      @map[@tile_position_in_array] = 0 if @tile_position_in_array
      @tile_position_in_array = x + y * (WIDTH / TILE_SIZE)
      if is_player_selected?
        @map[@tile_position_in_array] = 2
      else
        @map[@tile_position_in_array] = 1
      end
    end
  end

  def can_player_move_there?
    return false unless @player_last_movement_to
    tilepos_y = @player_last_movement_to / (WIDTH / TILE_SIZE)
    tilepos_x = @player_last_movement_to % (WIDTH / TILE_SIZE)
    player_can_move_y = (tilepos_y - (@player.y / TILE_SIZE)).abs <= @player.max_movement
    player_can_move_x = (tilepos_x - (@player.x / TILE_SIZE)).abs <= @player.max_movement
    player_can_move_y && player_can_move_x
  end

  def handle_input
  end

  def draw_current_camera_view
    (WIDTH  / TILE_SIZE).times do |x|
      (HEIGHT / TILE_SIZE).times do |y|
        Gosu.draw_rect((x * TILE_SIZE) + 1, (y * TILE_SIZE) + 1, TILE_SIZE - 2, TILE_SIZE - 2, Gosu::Color.argb(TILES[@map[x + y * (WIDTH / TILE_SIZE)]]))
      end
    end
  end

  def save_map
    File.write("save_file", @map.join('|'))
    puts "Saved."
  end

  def load_file(map_file_name)
    file_content = File.read(map_file_name)
    file_content.split("|").map(&:to_i)
  rescue Errno::ENOENT
    puts "File not found."
    []
  end

  # Utils
  def array_index_to_coords(array_index) # array_index == tile_pos, in my current vocabulary
    # Let me explain my future self what is the logic on this math:
    # Let's see what we have: we have an array_index, say, 317.
    # We have the WIDTH (in pixels), for the width of the entire screen
    # And we have the TILE_SIZE (also in pixes)
    # This allows me to know how many tiles do we have in the WIDTH of the screen
    # (the X axis)
    # So, if the screen has 1000px and the tile size is 10px, we know there are
    # 1000 / 10 tiles in the screen: 100 tiles.
    # If we are on the array position 317, it means that we have already crossed to rows
    # (the Y axis), since there are only 100 positions per Y row.
    # So, everything from 0 to 99 is in the first row; from 100 to 199 in the second;
    # and 300-399 in the third.
    # So, if we divide our number by the number of tiles and get the floor of it:
    # 317 / 100 = 3.17
    # So, y = 3
    # If you do the modulus with 100, on the other side, you'll have the X, meaning:
    # how much did we move since the first position of the row (which is 0)
    # Hope that helps!
    [(array_index % (WIDTH / TILE_SIZE)) * TILE_SIZE, (array_index / (WIDTH / TILE_SIZE)) * TILE_SIZE]
  end
end

#Map.new(map_file: "save_file").show
Map.new.show
