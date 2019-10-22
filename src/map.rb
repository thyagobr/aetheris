require 'gosu'

class Map < Gosu::Window
  WIDTH = 800
  HEIGHT = 640
  MAP_WIDTH = WIDTH * 4
  MAP_HEIGHT = HEIGHT * 2
  TILE_SIZE = 16

  def initialize
    super(WIDTH, HEIGHT, fullscreen = false)
    @map = []
    (HEIGHT / TILE_SIZE).times do |y|
      @map << []
      (WIDTH / TILE_SIZE).times do |x|
        @map[y] << Gosu::Color.argb(0xbb_00aa00)
      end
    end
  end

  def needs_cursor?; true; end

  def button_down(id)
    close if id == Gosu::KbEscape
    save_map if id == Gosu::KbS
  end

  def left_click
    x = mouse_x / TILE_SIZE
    y = mouse_y / TILE_SIZE
    @map[y][x] = Gosu::Color.argb(0xbb_f0aa00)
  end

  def draw
    left_click if button_down?(Gosu::MsLeft)

    (WIDTH / TILE_SIZE).times do |x|
      (HEIGHT / TILE_SIZE).times do |y|
        Gosu.draw_rect(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, @map[y][x])
      end
    end
  end
end

Map.new.show
