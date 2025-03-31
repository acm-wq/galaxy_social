class Planet
  attr_accessor :id, :name, :star_id

  def initialize(attributes = {})
    @id = self.class.next_id
    @name = attributes["name"]
  end

  def save
    $redis.set("planet:#{@id}", self.to_json)
    @id
  end

  def self.find_by_name(name)
    planet = $redis.get("planet:#{name}")
    return nil if planet.nil?
    JSON.parse(planet)
  end

  def self.next_id
    $redis.incr("planet:id")
  end

  def to_json(*_args)
    { id: @id, name: @name }.to_json
  end
end
