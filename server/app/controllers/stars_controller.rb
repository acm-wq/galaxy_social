# The StarsController handles actions related to managing stars in the application.
# It provides endpoints for retrieving random stars, fetching specific stars by ID,
# and creating new stars.

# Actions:
# - random: Fetches a random star that is not in the excluded list provided via parameters.
#           Responds with an error if no more stars are available.
#           Route: GET /stars/random
#           Params:
#             - list_stars (optional): Array of star names to exclude from the random selection.
#           Responses:
#             - 200 OK: Returns the random star data in JSON format.
#             - 404 Not Found: If no more stars are available.

# - show: Fetches a specific star by its ID from the Redis cache.
#         Responds with an error if the star is not found.
#         Route: GET /stars/:id
#         Params:
#           - id (required): The ID of the star to fetch.
#         Responses:
#           - 200 OK: Returns the star data in JSON format.
#           - 404 Not Found: If the star is not found.

# - create: Creates a new star with the provided parameters.
#           Responds with the created star's ID and a success message if successful.
#           Route: POST /stars
#           Params:
#             - star (required): A hash containing the following attributes:
#               - name (string): The name of the star.
#               - password (string): The password associated with the star.
#               - type_star (string): The type/category of the star.
#           Responses:
#             - 201 Created: If the star is successfully created.
#             - 422 Unprocessable Entity: If the star creation fails.
class StarsController < ApplicationController
  # GET /stars/random
  def random
    excluded_names = params[:list_stars] || []

    random_key = StarCollection.get_random_star_key(excluded_names)

    if random_key.nil?
      render json: { error: "No more stars available" }, status: :not_found
    else
      star_data = Star.find_by_code(random_key)
      render json: JSON.parse(star_data), status: :ok
    end
  end

  # GET /stars/:id
  def show
    star_data = $redis.get("star:#{params[:id]}")

    puts star_data
    if star_data.nil?
      render json: { error: "Star not found" }, status: :not_found
    else
      render json: JSON.parse(star_data), status: :ok
    end
  end

  # POST /stars
  def create
    star = Star.new(params.require(:star).permit(:name, :password, :type_star))

    if star.save
      render json: { id: star.key, message: "Star created successfully" }, status: :created
    else
      render json: { error: "Failed to create star" }, status: :unprocessable_entity
    end
  end

  # POST /stars/:id/planets
  def add_planet
    star = Star.find_by_code(params[:id])
    return render json: { error: "Star not found" }, status: :not_found if star.nil?

    planet = Planet.new(params.require(:planet).permit(:name, :type_planet))
    if planet.save
      star.add_planet(planet)
      render json: { message: "Planet added to star successfully" }, status: :ok
    else
      render json: { error: "Failed to add planet" }, status: :unprocessable_entity
    end
  end
end
