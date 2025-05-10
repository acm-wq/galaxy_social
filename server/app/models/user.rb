# frozen_string_literal: true

class User
  include UniqueCodeGenerator
  include BCrypt

  attr_accessor :name, :password
  attr_reader :key

  def initialize(attributes = {})
    @key = attributes["id"] || self.class.generate_unique_code(prefix: "USER")
    @name = attributes["name"]
    @password = attributes["password"]
  end

  def save
    $redis.set("user:#{@key}", self.to_json)

    @key
  end

  def self.authentificate(key, password)
    user = $redis.get("user:#{key}")
    return nil if user.nil? || user.empty?

    user = JSON.parse(user)
    return nil unless Password.new(user["password"]) == password

    new(user)
  end

  def self.find_by_code(key)
    user = $redis.get("user:#{key}")
    return nil if user.nil? || user.empty?
    user = JSON.parse(user)
    return nil unless user["key"] == key

    new(user)
  end

  private

  def to_json(*_args)
    {
      name: @name,
      password: @password
    }.to_json
  end
end
