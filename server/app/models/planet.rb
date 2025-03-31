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
