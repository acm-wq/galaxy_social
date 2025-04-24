#
class Star
  include UniqueCodeGenerator

  # This is a real small classification of stars in our universe.
  # The classification is based on the temperature and color of the star.
  # O stars are blue.
  # A stars are white.
  # G stars are yellow.
  # K stars are orange.
  # M stars are red.
  STAR_TYPES = %w[O A G K M].freeze

  attr_accessor :name, :planet_ids
  attr_reader :key

  after_save :set_path_for_star

  def initialize(attributes = {})
    @key = attributes["id"] || self.class.generate_unique_code
    @name = attributes["name"]
    @password = attributes["password"]
    @type_star = attributes["type_star"] || "G"
    @avatar = attributes["avatar"]
    @planet_ids = attributes["planet_ids"] || []
  end

  def save
    $redis.set("star:#{@key}", self.to_json)
    StarCollection.add_star(@key)

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

  private

  def to_json(*_args)
    return nil unless valid_type_star?

    {
      key: @key,
      name: @name,
      password: @password,
      type_star: @type_star,
      avatar: set_path_for_star(@type_star)
    }.to_json
  end

  def valid_type_star?
    STAR_TYPES.include?(@type_star)
  end

  def set_path_for_star(type_star)
    path = File.join(StarCollection::STARS_PATH, "#{@key}.json")
    File.write(path, to_json)
  end
end
