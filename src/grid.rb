require './src/map'

class Grid
  def self.draw(x:, y:, range:, map:)
    left = (x / Map::TILE_SIZE) - range
    top = (y / Map::TILE_SIZE) - range
    right = (x / Map::TILE_SIZE) + range
    bottom = (y / Map::TILE_SIZE) + range

    left = 0 if left < 0
    top = 0 if top < 0
    right = (Map::WIDTH / Map::TILE_SIZE) if right > (Map::WIDTH / Map::TILE_SIZE)
    bottom = (Map::HEIGHT / Map::TILE_SIZE) if bottom > (Map::HEIGHT / Map::TILE_SIZE)

    puts "#{left}, #{top}, #{right}, #{bottom}"

    (top..bottom).each do |y|
      (left..right).each do |x|
        tile_pos = x + y * (Map::WIDTH / Map::TILE_SIZE)
        next if tile_pos == map.player_tile_position
        map.map[tile_pos] = map.player_moving ? 3 : 0
      end
    end
  end

  def self.clear(x:, y:, range:, map:)
    left = (x / Map::TILE_SIZE) - range
    top = (y / Map::TILE_SIZE) - range
    right = (x / Map::TILE_SIZE) + range
    bottom = (y / Map::TILE_SIZE) + range

    left = 0 if left < 0
    top = 0 if top < 0
    right = (Map::WIDTH / Map::TILE_SIZE) if right > (Map::WIDTH / Map::TILE_SIZE)
    bottom = (Map::HEIGHT / Map::TILE_SIZE) if bottom > (Map::HEIGHT / Map::TILE_SIZE)

    puts "#{left}, #{top}, #{right}, #{bottom}"

    (top..bottom).each do |y|
      (left..right).each do |x|
        tile_pos = x + y * (Map::WIDTH / Map::TILE_SIZE)
        next if tile_pos == map.player_tile_position
        map.map[tile_pos] = 0
      end
    end
  end
end
