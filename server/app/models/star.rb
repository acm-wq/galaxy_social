# frozen_string_literal: true

#
# The Star class represents a star entity with attributes.
# It includes functionality for generating unique codes, saving to a Redis database, and managing associated planets.
#
# Constants:
# - STAR_TYPES: A hash mapping star classifications (O, A, G, K, M) to their corresponding colors.
#
# Attributes:
# - name [String]: The name of the star.
# - password [String]: A password associated with the star (for future auth or security features).
# - type_star [Symbol]: The spectral classification of the star (e.g., :O, :G).
# - avatar [String]: The file path for the star's avatar image, based on its classification.
# - planet_ids [Array<String>]: An array of associated planet IDs.
# - key [String]: A unique identifier for the star (read-only).
#
# Instance Methods:
# - initialize(attributes = {}): Initializes a new Star object with the given attributes.
# - save: Saves the star object to Redis and adds it to the StarCollection.
# - add_planet(planet): Adds a planet to the star's associated planets and saves the star.
# - planet_ids: Returns the list of associated planet IDs.
#
# Class Methods:
# - self.find_by_code(key): Finds a star by its unique key in Redis.
#
# Private Methods:
# - to_json(*_args): Converts the star object to a JSON representation if the type is valid.
# - valid_type_star?: Checks if the star's type is valid based on STAR_TYPES.
# - set_path_for_star: Sets the file path for the star's avatar based on its type.
class Star
  include UniqueCodeGenerator

  # This is a real small classification of stars in our universe.
  # The classification is based on the temperature and color of the star.
  STAR_TYPES = {
    O: "blue",
    A: "white",
    G: "yellow",
    K: "orange",
    M: "red"
  }.freeze

  attr_accessor :name, :planet_ids
  attr_reader :key

  def initialize(attributes = {})
    @key = attributes["id"] || self.class.generate_unique_code
    @name = attributes["name"]
    @password = attributes["password"]
    @type_star = (attributes["type_star"] || :G).to_sym
    @avatar = set_path_for_star
    @planet_ids = attributes["planet_ids"] || []
  end

  def save
    $redis.set("star:#{@key}", self.to_json)
    StarCollection.add_star(@key)

    @key
  end

  def self.find_by_code(key)
    star = $redis.get("star:#{key}")
    return nil if star.nil? || star.empty?

    star
  end

  def add_planet(planet)
    @planet_ids << planet.name
    save
  end

  def planet_ids
    @planet_ids
  end

  private

  def to_json(*_args)
    return nil unless valid_type_star?

    {
      key: @key,
      name: @name,
      password: @password,
      type_star: @type_star,
      avatar: @avatar,
      planet_ids: @planet_ids
    }.to_json
  end

  def valid_type_star?
    STAR_TYPES.include?(@type_star)
  end

  def set_path_for_star
    @avatar = "/star/#{STAR_TYPES[@type_star]}_star.gif"
  end
end
