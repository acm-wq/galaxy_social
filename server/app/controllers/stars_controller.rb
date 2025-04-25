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
    star_params = params.require(:star).permit(:name, :password, :type_star)
    star = Star.new(star_params.to_h)

    if star.save
      render json: { id: star.key, message: "Star created successfully" }, status: :created
    else
      render json: { error: "Failed to create star" }, status: :unprocessable_entity
    end
  end
end
