require 'gosu'

class Main < Gosu::Window
  WIDTH = 800
  HEIGHT = 640
  MAP_WIDTH = WIDTH * 4
  MAP_HEIGHT = HEIGHT * 2

  def initialize
    super(WIDTH, HEIGHT, fullscreen = false)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def update
  end

  def draw
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color.argb(0xbb_00AA00))
  end

  def needs_cursor?; true; end
end

Main.new.show
