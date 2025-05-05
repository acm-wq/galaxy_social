# The StarCollection class provides methods to manage a collection of stars stored.
# It allows adding stars, retrieving a random star key while excluding specific names,
# and checking if any stars exist in the collection.
#
# Constants:
# - LIST_STAR: A frozen string key used to store the list of star keys in Redis.
#
# Class Methods:
# - .add_star(key): Adds a star key to the Redis list. Does nothing if the key is nil.
#   @param key [String] The key of the star to add.
#
# - .get_random_star_key(excluded_names): Retrieves a random star key from the Redis list,
#   excluding stars with names in the provided exclusion list. Returns nil if no valid star is found.
#   @param excluded_names [Array<String>] A list of star names to exclude.
#   @return [String, nil] The key of a random star or nil if no valid star is found.
#
# - .any_stars?: Checks if there are any stars in the Redis list.
#   @return [Boolean] True if the list exists, false otherwise.
class StarCollection
  LIST_STAR = "star_keys".freeze

  def self.add_star(key)
    return unless key
    $redis.rpush(LIST_STAR, key)
  end

  def self.update_planets_for_star(star_key, planet_name)
    star_data = $redis.get("star:#{star_key}")
    return false unless star_data

    star = JSON.parse(star_data)

    star["planet_ids"] ||= []
    star["planet_ids"] << planet_name unless star["planet_ids"].include?(planet_name)

    $redis.del("star:#{star_key}")

    $redis.set("star:#{star_key}", star.to_json)

    true
  end

  def self.get_random_star_key(excluded_names)
    return nil unless $redis.exists?(LIST_STAR)

    total_stars = $redis.llen(LIST_STAR)
    return nil if total_stars.zero?

    excluded_names_set = Set.new(excluded_names)
    attempts = 0

    while attempts < total_stars
      random_index = rand(total_stars)
      random_key = $redis.lindex(LIST_STAR, random_index)
      star_data = $redis.get("star:#{random_key}")
      next if star_data.nil?

      star = JSON.parse(star_data)
      return random_key unless excluded_names_set.include?(star["name"])

      attempts += 1
    end

    nil
  end

  def self.any_stars?
    $redis.exists?(LIST_STAR)
  end
end
