#
class Star
  include UniqueCodeGenerator

  attr_accessor :name, :planet_ids
  attr_reader :key

  def initialize(attributes = {})
    @key = attributes["id"] || self.class.generate_unique_code
    @name = attributes["name"]
    @password = attributes["password"]
    @planet_ids = attributes["planet_ids"] || []
  end

  def save
    $redis.set("star:#{@key}", self.to_json)
    @key
  end

  def self.find_by_code(key)
    star = $redis.get("star:#{key}")
    return nil if star.empty?
    star
  end

  def add_planet(planet)
    @planet_ids << planet.id
    save
  end

  def planet_ids
    @planet_ids
  end

  def to_json(*_args)
    { name: @name, password: @password }.to_json
  end
end
