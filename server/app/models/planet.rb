class Planet
  attr_accessor :id, :name, :star_id

  def initialize(attributes = {})
    @id = attributes["id"]
    @name = attributes["name"]
    @star_id = attributes["star_id"]
  end

  def save
    $redis.set("planet:#{self.id}", self.to_json)
  end

  def to_json(*_args)
    { id: @id, name: @name, star_id: @star_id }.to_json
  end
end
