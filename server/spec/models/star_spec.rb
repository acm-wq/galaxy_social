require 'rails_helper'
require 'mock_redis'

RSpec.describe Star, type: :model do
  let(:redis) { MockRedis.new }
  let(:star_attributes) do
    {
      "name" => "The Great Star",
      "password" => "mysecretpassword",
      "type_star" => "G",
      "planet_ids" => [ "planet1", "planet2" ]
    }
  end

  before do
    stub_const("REDIS", redis)
  end

  describe '#initialize' do
    it 'initializes a star with the given attributes' do
      star = Star.new(star_attributes)

      expect(star.name).to eq("The Great Star")
      expect(star.planet_ids).to eq([ "planet1", "planet2" ])
      expect(star.instance_variable_get(:@password)).to eq("mysecretpassword")
      expect(star.instance_variable_get(:@type_star)).to eq(:G)
      expect(star.instance_variable_get(:@avatar)).to eq("/star/yellow_star.gif")
    end
  end

  describe '#save' do
    it 'saves the star to Redis and adds it to the StarCollection' do
      star = Star.new(star_attributes)
      allow(StarCollection).to receive(:add_star)

      key = star.save

      expect($redis.get("star:#{key}")).not_to be_nil
      expect(StarCollection).to have_received(:add_star).with(key)
    end
  end

  describe '.find_by_code' do
    it 'retrieves a star by its key from Redis' do
      star = Star.new(star_attributes)
      key = star.save

      found_star = Star.find_by_code(key)

      expect(found_star).to eq($redis.get("star:#{key}"))
    end

    it 'returns nil if the star is not found' do
      expect(Star.find_by_code("nonexistent_key")).to be_nil
    end
  end
end
