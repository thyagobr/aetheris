require 'gosu'
require 'byebug'
require './src/player'
require './src/actions/attack'
require './src/grid'

class Map < Gosu::Window
  attr_accessor :tile_position_in_array, :player_moving, :map

  TILE_SIZE = 64
  WIDTH = TILE_SIZE * 20
  HEIGHT = TILE_SIZE * 16
  MAP_WIDTH = WIDTH * 4
  MAP_HEIGHT = HEIGHT * 2

  # todo: turn this into a hash - using actual tile names or colors
  TILES = [
    0xbb_00aa00, # Green       - standard tile
    0xbb_f0aa00, # Sand yellow - random selection
    0xbb_c00080, # Pink        - selected player
    0xbb_0f5477, # Dark purple - highlighted possible movement 
    0xbb_f70000, # Red         - non-selectable movement
    0xbb_f70390  # ...         - selected movement desination
  ]

  # Args may include:
  # - map_file: (file_path) - Load a specific file for map
  def initialize(**args)
    super(WIDTH, HEIGHT, fullscreen = false)
    load_map(args)
    spawn_players
    start_turn!

    @byebug = false
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
    # press W to highlight current player's movements possibilities
    # press W to un-highlight or
    # select destination and press W to go - ends turn
    if button_down?(Gosu::KbW)
      if @player_moving
        @player_moving = false
        Grid.clear(x: current_player.x, y: current_player.y, range: current_player.max_movement, map: self)
        # This variable exists to know where the user last clicked
        if @player_last_movement_to && can_player_move_there?
          # reset the color of former player selection tile
          @map[player_tile_position] = 0
          # reset the color of selectable movement to
          @map[@player_last_movement_to] = 0
          # break the [x, y] array into x, y variables and warps the player
          # to the correct position.
          current_player.warp(*array_index_to_coords(@player_last_movement_to))
          next_player_in_turn!
          # reset the last tile selected tracker
          @player_last_movement_to = nil
        end
      else
        @player_moving = true
        Grid.draw(x: current_player.x, y: current_player.y, range: current_player.max_movement, map: self)
      end
    elsif button_down?(Gosu::KbA)
      Actions::Attack.perform(character: current_player)
    end
  end

  def update
    handle_input
  end

  def draw
    @players.each(&:draw)

    draw_current_camera_view
  end

  # todo: document the map format and logic
  def load_map(args)
    if args[:map_file]
      puts "Loading file: #{args[:map_file]}"
      @map = load_file(args[:map_file])
    else
      @map = []

      # todo: this loop happens a lot. Maybe accept the loops and yield x and y
      # (or yield a direct access to the correct array position each turn?)
      (WIDTH / TILE_SIZE).times do |x|
        (HEIGHT / TILE_SIZE).times do |y|
          @map[x + y * (WIDTH / TILE_SIZE)] = 0
        end
      end
    end
  end

  def spawn_players
    @players = []
    @players << Player.new(self)
    player_2 = Player.new(self)
    player_2.x = TILE_SIZE * 6
    player_2.y = TILE_SIZE * 8
    @players << player_2
    @current_player_index = 0
    @player_moving = false
  end

  def current_player
    @players[@current_player_index]
  end

  # Tile position is the position in the array number
  def player_tile_position
    player_x = current_player.x / TILE_SIZE # position in the array axis
    player_y = current_player.y / TILE_SIZE # position in the array axis
    player_x + player_y * (WIDTH / TILE_SIZE)
  end

  def is_player_selected?
    @tile_position_in_array && player_tile_position == @tile_position_in_array
  end

  def gotcha
    byebug if @byebug
  end

  def left_click
    x = mouse_x.to_i / TILE_SIZE
    y = mouse_y.to_i / TILE_SIZE
    if @player_moving
      player_intended_movement_to = x + y * (WIDTH / TILE_SIZE)
      # this means: if the player didn't select his own character's tile
      if not player_intended_movement_to == player_tile_position
        # reset former selection to standard_color
        @map[@player_last_movement_to] = @player_last_movement_to_tile_type if @player_last_movement_to
        # which tile (array poisition) did the player just clicked at:
        @player_last_movement_to = player_intended_movement_to
        # let's remember what it was before we change it to highlighted selection
        @player_last_movement_to_tile_type = @map[@player_last_movement_to]
        # if we can move there, let's select the highlighted color
        # (this choice was meaningful when you could click outside of the movement
        # grid. It's not the case at the moment, but it doesn't interfere with the logic)
        tile_selection_color = can_player_move_there? ? 5 : @player_last_movement_to_tile_type
        # update the map color to movement_selection
        @map[@player_last_movement_to] = tile_selection_color
      else
        # if the player clicked on him/herself, let simply
        # reset the former selection to standard movement grid color
        @map[@player_last_movement_to] = 3 if @player_last_movement_to
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
    player_can_move_y = (tilepos_y - (current_player.y / TILE_SIZE)).abs <= current_player.max_movement
    player_can_move_x = (tilepos_x - (current_player.x / TILE_SIZE)).abs <= current_player.max_movement
    player_can_move_y && player_can_move_x
  end

  def handle_input
    left_click if button_down?(Gosu::MsLeft) # temp
    @byebug = !@byebug if button_down?(Gosu::KbB)
  end

  def draw_current_camera_view
    (WIDTH  / TILE_SIZE).times do |x|
      (HEIGHT / TILE_SIZE).times do |y|
        Gosu.draw_rect((x * TILE_SIZE) + 1, (y * TILE_SIZE) + 1, TILE_SIZE - 2, TILE_SIZE - 2, Gosu::Color.argb(TILES[@map[x + y * (WIDTH / TILE_SIZE)]]))
      end
    end
  end

  def start_turn!
    @map[player_tile_position] = 2
  end

  def next_player_in_turn!
    @current_player_index = (@current_player_index + 1) % @players.size
    @map[player_tile_position] = 2
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
