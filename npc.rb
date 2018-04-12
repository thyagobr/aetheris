class NPC
  def initialize
    @sprite = Gosu::Image.new(Utils.image_path_for("crisiscorepeeps"), rect: [32 * 6, 0, 32, 32])
    @x = 400
    @y = 30
  end

  def draw(camera)
    @sprite.draw(camera.x + @x, camera.y + @y, 1, 2, 2)

    if @spell_aof_start_cast
      color = Gosu::Color.argb(0xbb_ff0000)
      alpha = (Gosu::milliseconds / 3) % 400
      alpha = 200 - (alpha - 200) if alpha > 200
      color.alpha = alpha
      #Gosu.draw_rect(camera.x + @x, camera.y + @y, 32 * 2, 640, color) 
      puts "camera x,y: #{camera.x}, #{camera.y}"
      puts "target x,y: #{@target.x}, #{@target.y}"
      Gosu.draw_quad(camera.x + @x, camera.y + @y, color,
                     camera.x + @x + 64, camera.y + @y, color,
                     camera.x.abs + @target.x, camera.y.abs + @target.y + 32, color,
                     camera.x.abs + @target.x + 32, camera.y.abs + @target.y + 32, color,
                     1)

      if Gosu::milliseconds - @spell_aof_start_cast > 3000
        @spell_aof_start_cast = nil
      end
    end
  end

  def collision_box(camera)
    x = camera.x + @x
    y = camera.y + @y
    CollisionBox.new(x, y, x + 32, y + 32)
  end

  def cast(target)
    @target = target if target
    @spell_aof_start_cast ||= Gosu::milliseconds
  end
end
