class NPC
  def initialize
    @sprite = Gosu::Image.new(Utils.image_path_for("crisiscorepeeps"), rect: [32 * 6, 0, 32, 32])
  end

  def draw(camera)
    @sprite.draw(camera.x + 80, camera.y + 400, 1, 2, 2)
  end

  def collision_box(camera)
    x = camera.x + 80
    y = camera.y + 400
    CollisionBox.new(x, y, x + 32, y + 32)
  end
end
