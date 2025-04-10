class StarCollection
  LIST_STAR = "star_keys".freeze

  def self.add_star(key)
    return unless key
    $redis.rpush(LIST_STAR, key)
  end

  def self.get_random_star_key
    return nil unless $redis.exists?(LIST_STAR)

    total_stars = $redis.llen(LIST_STAR)
    return nil if total_stars.zero?

    random_index = rand(total_stars)
    $redis.lindex(LIST_STAR, random_index)
  end

  def self.any_stars?
    $redis.exists?(LIST_STAR)
  end
end
