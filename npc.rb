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
      Gosu.draw_quad(camera.x + @x - 50, camera.y + @y + 64, color,
                     camera.x + @x + 50 + 64, camera.y + @y + 64, color,
                     camera.x + @x - 50, camera.y + @y + 400, color,
                     camera.x + @x + 50 + 64, camera.y + @y + 400, color,
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
