url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'

# Initialize Redis
$redis = Redis.new(url: url)

Rails.application.config.cache_store = :redis_cache_store, { url: url, namespace: 'galaxy_social_store' }