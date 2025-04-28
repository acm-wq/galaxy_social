class PlanetsController < ApplicationController
  # GET /planets/:id
  def show
    planet_data = $redis.get("planet:#{params[:id]}")

    if planet_data.nil?
      render json: { error: "planet not found" }, status: :not_found
    else
      render json: JSON.parse(planet_data), status: :ok
    end
  end

  # POST /planets
  def create
    planet = Planet.new(params.require(:planet).permit(:name, :type_planet))

    if planet.save
      render json: { name: planet.name, message: "Planet created successfully" }, status: :created
    else
      render json: { error: "Failed to create planet" }, status: :unprocessable_entity
    end
  end
end
