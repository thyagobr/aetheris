class CollisionBox
  attr_accessor :top, :left, :bottom, :right

  def initialize(left,top, right, bottom)
    self.left = left
    self.top = top
    self.right = right
    self.bottom = bottom
  end

  def collided_with(other_box)
    return !(self.right <= other_box.left or
             self.left >= other_box.right or
             self.bottom <= other_box.top or
             self.top >= other_box.bottom)
  end
end
