class Weapon
  attr_accessor :range, :base_dice

  def initialize(**args)
    @range = args[:range]
    @base_dice = args[:base_dice]
  end
end


