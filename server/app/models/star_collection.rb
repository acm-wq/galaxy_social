class StarCollection
  LIST_STAR = "star_keys".freeze

  def self.add_star(key)
    return unless key
    $redis.rpush(LIST_STAR, key)
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
