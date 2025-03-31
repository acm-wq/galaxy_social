#
class Star
  include UniqueCodeGenerator

  attr_accessor :id, :name, :planet_ids

  def initialize(attributes = {})
    @id = attributes["id"] || self.class.generate_unique_code
    @name = attributes["name"]
    @password = attributes["password"]
    @planet_ids = attributes["planet_ids"] || []
  end

  def save
    $redis.set("star:#{self.id}", self.to_json)
  end

  def self.find_by_name(name)
    keys = $redis.scan_each(match: "star:*").to_a
    keys.each do |key|
      star_data = JSON.parse($redis.get(key))
      return Star.new(star_data) if star_data["name"] == name
    end
    nil
  end

  def add_planet(planet)
    @planet_ids << planet.id
    save
  end

  def planets
    @planet_ids.map do |planet_id|
      planet_data = JSON.parse($redis.get("planet:#{planet_id}"))
      Planet.new(planet_data) if planet_data
    end.compact
  end

  def to_json(*_args)
    { id: @id, name: @name, password: @password, planet_ids: @planet_ids }.to_json
  end
end