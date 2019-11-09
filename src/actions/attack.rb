module Actions
  class Attack
    def self.perform(character:, map:)
      puts "Rolling 1d#{character.weapon.base_dice}"
      Grid.draw(x: character.x, y: character.y, range: character.weapon.range, map: map, tile: 5)
    end
  end
end
