require 'gosu'
require 'byebug'

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

  def initialize(**args)
    super(WIDTH, HEIGHT, fullscreen = false)
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

  def needs_cursor?; true; end

  def button_down(id)
    close if id == Gosu::KbEscape
    save_map if id == Gosu::KbS
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

  def left_click
    x = mouse_x.to_i / TILE_SIZE
    y = mouse_y.to_i / TILE_SIZE
    @map[x + y * (WIDTH / TILE_SIZE)] = 1
    puts "#{x},#{y}"
  end

  def draw
    left_click if button_down?(Gosu::MsLeft)

    (WIDTH  / TILE_SIZE).times do |x|
      (HEIGHT / TILE_SIZE).times do |y|
        Gosu.draw_rect(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, Gosu::Color.argb(TILES[@map[x + y * (WIDTH / TILE_SIZE)]]))
      end
    end
  end
end

Map.new(map_file: "save_file").show
