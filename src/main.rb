require 'gosu'
require './src/player'

class Main < Gosu::Window
  WIDTH = 800
  HEIGHT = 640
  MAP_WIDTH = WIDTH * 4
  MAP_HEIGHT = HEIGHT * 2

  def initialize
    super(WIDTH, HEIGHT, fullscreen = false)
    @map = Gosu::Image.new("images/map.jpg")
    @low_grass = @map.subimage(32, 32 * 2, 22, 22)
    @player = Player.new(self)
    @player.warp(300, 200)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def update
  end

  def draw
    @player.draw
    player_tile = (WIDTH / @player.x).to_i * 32
    puts player_tile
    @low_grass.draw(@player.x, @player.y, 0, 2, 2)
    @low_grass.draw(@player.x - 32, @player.y - 32, 0, 2, 2)
    @low_grass.draw(@player.x, @player.y - 32, 0, 2, 2)
    @low_grass.draw(@player.x - 32, @player.y, 0, 2, 2)
    @low_grass.draw(@player.x + 32, @player.y + 32, 0, 2, 2)
    @low_grass.draw(@player.x, @player.y + 32, 0, 2, 2)
    @low_grass.draw(@player.x + 32, @player.y, 0, 2, 2)
    @low_grass.draw(@player.x + 32, @player.y - 32, 0, 2, 2)
    @low_grass.draw(@player.x - 32, @player.y + 32, 0, 2, 2)
  end

  def needs_cursor?; true; end
end

Main.new.show
