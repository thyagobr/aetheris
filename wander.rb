class Game
  attr_accessor :ore, :wood, :vegetable

  def initialize
    @ore = @wood = @vegetable = 0
  end

  def wander
    ore = wood = vegetable = 0

    print "*** Você entra na floresta"

    10.times do
      print "."
      case Random.rand(1..100)
      when 1..5
        ore += 1
      when 6..10
        wood += 1
      when 11..15
        vegetable += 1
      end
      sleep 1
    end
    puts "."

    if ore > 0
      puts "Minérios encontrados: #{ore}"
      @ore += ore
    end

    if wood > 0
      puts "Madeiras encontrandas: #{wood}"
      @wood += wood
    end

    if vegetable > 0
      puts "Vegetais encontrados: #{vegetable}"
      @vegetable += vegetable
    end
  end
end
