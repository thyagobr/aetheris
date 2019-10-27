require 'gosu'
require 'byebug'
require './src/player'

class Map < Gosu::Window
  WIDTH = 800
  HEIGHT = 640
  MAP_WIDTH = WIDTH * 4
  MAP_HEIGHT = HEIGHT * 2
  TILE_SIZE = 16

  TILES = [
    0xbb_00aa00,
    0xbb_f0aa00
  ]

  # Args may include:
  # - map_file: (file_path) - Load a specific file for map
  def initialize(**args)
    super(WIDTH, HEIGHT, fullscreen = false)

    load_map(args)
    spawn_player
  end

  def needs_cursor?; true; end

  def button_down(id)
    close if id == Gosu::KbEscape
    save_map if id == Gosu::KbS
  end

  def update
    left_click if button_down?(Gosu::MsLeft) # temp
    handle_player_movement
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
  end

  def left_click x = mouse_x.to_i / TILE_SIZE
    y = mouse_y.to_i / TILE_SIZE
    @map[x + y * (WIDTH / TILE_SIZE)] = 1
  end

  def handle_player_movement
    if button_down?(Gosu::KbRight)
      @player.right
    end
    if button_down?(Gosu::KbLeft)
      @player.left
    end
    if button_down?(Gosu::KbUp)
      @player.up
    end
    if button_down?(Gosu::KbDown)
      @player.down
    end
  end

  def draw_current_camera_view
    (WIDTH  / TILE_SIZE).times do |x|
      (HEIGHT / TILE_SIZE).times do |y|
        Gosu.draw_rect(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, Gosu::Color.argb(TILES[@map[x + y * (WIDTH / TILE_SIZE)]]))
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
end

#Map.new(map_file: "save_file").show
Map.new.show
