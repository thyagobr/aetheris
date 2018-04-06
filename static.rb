require 'gosu'

class Screen < Gosu::Window
  WIDTH = 800
  HEIGHT = 600

  MAP_WIDTH = 1008 * 2
  MAP_HEIGHT = 689 * 2

  def initialize
    @x = 0
    @y = 0
    @speed = 5
    super(WIDTH, HEIGHT, fullscreen = false)
    @map = Gosu::Image.new(self, "images/map.jpg", true, 0, 0, MAP_WIDTH, MAP_HEIGHT)
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @x += (@x + @speed >= 0 ? 0 : @speed)
    end
    
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @x -= (@x - @speed <= WIDTH - MAP_WIDTH ? 0 : @speed)
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpUp then
      @y += (@y + @speed >= 0 ? 0 : @speed)
    end
    
    if button_down? Gosu::KbDown or button_down? Gosu::GpDown then
      @y -= (@y - @speed <= HEIGHT - MAP_HEIGHT ? 0 : @speed)
    end
  end

  def draw
    puts "#{@x},#{@y}"
    @map.draw(@x, @y, 0, 2, 2)
  end
end

Screen.new.show
