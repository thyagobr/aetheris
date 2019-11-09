module Actions
  class Attack
    def self.perform(character:)
      puts "Rolling 1d#{character.weapon.base_dice}"
    end
  end
end
