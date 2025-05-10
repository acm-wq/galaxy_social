module UniqueCodeGenerator
  extend ActiveSupport::Concern

  included do
    REDIS_UNIQUE_CODE_KEY = "unique_code_generator:#{self.name.downcase}:counter".freeze
  end

  class_methods do
    def generate_unique_code(prefix: 'STAR', length: 8)
      counter = $redis.incr(REDIS_UNIQUE_CODE_KEY)

      random_component = SecureRandom.hex(4)

      unique_code = "#{prefix}#{counter.to_s.rjust(length, '0')}#{random_component}"
      unique_code
    end
  end
end
