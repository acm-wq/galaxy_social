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
    permitted = params.require(:planet).permit(:name, :type_planet, :star_key)
    planet = Planet.new(permitted.except(:star_key))

    if planet.save
      if permitted[:star_key].present?
        star_data = Star.find_by_code(permitted[:star_key])

        if star_data
          star = Star.new(JSON.parse(star_data))
          star.add_planet(planet)
        else
          return render json: { error: "Star not found with key: #{permitted[:star_key]}" }, status: :not_found
        end
      end

      render json: { name: planet.name, message: "Planet created and linked successfully" }, status: :created
    else
      render json: { error: "Failed to create planet" }, status: :unprocessable_entity
    end
  end
end
