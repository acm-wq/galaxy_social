# The Planet class represents a planet entity with a name attribute.
# It provides functionality to save a planet and retrieve it by name.
#
# Attributes:
# - name (String): The name of the planet.
#
# Public Methods:
# - initialize(attributes = {}): Initializes a new Planet object with the given attributes.
#   - attributes (Hash): A hash containing the planet's attributes (e.g., { "name" => "Earth" }).
#
# - save: Saves the planet to the Redis database after validating its attributes.
#   - Raises an error if the name is blank or not unique.
#   - Returns the name of the planet upon successful save.
#
# - self.find_by_name(name): Finds a planet by its name from the Redis database.
#   - name (String): The name of the planet to search for.
#   - Returns the planet data as a Hash if found, or nil if not found.
#
# - to_json(*_args): Converts the planet object to a JSON representation.
#   - Returns a JSON string containing the planet's attributes.
#
# Private Methods:
# - validate!: Validates the planet's attributes before saving.
#   - Raises an error if the name is blank or if a planet with the same name already exists in Redis.
class Planet
  attr_accessor :name

  def initialize(attributes = {})
    @name = attributes["name"]
  end

  def save
    validate!
    $redis.set("planet:#{@name}", self.to_json)
    @name
  end

  def self.find_by_name(name)
    planet_name = $redis.get("planet_name:#{name.downcase}")
    return nil if planet_name.nil?

    planet_data = $redis.get("planet:#{planet_name}")
    return nil if planet_data.nil?

    JSON.parse(planet_data)
  end

  def to_json(*_args)
    { name: @name }.to_json
  end

  private

  def validate!
    raise "Name can't be blank" if @name.nil? || @name.strip.empty?
    raise "Name must be unique" if $redis.exists?("planet:#{@name}")
  end
end
