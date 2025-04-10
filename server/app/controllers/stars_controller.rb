class StarsController < ApplicationController
  # GET /stars/:id
  def show
    star_data = $redis.get("star:#{params[:id]}")

    if star_data.nil?
      render json: { error: "Star not found" }, status: :not_found
    else
      render json: JSON.parse(star_data), status: :ok
    end
  end

  # POST /stars
  def create
    star_params = params.require(:star).permit(:name, :password)
    star = Star.new(star_params.to_h)

    if star.save
      render json: { id: star.key, message: "Star created successfully" }, status: :created
    else
      render json: { error: "Failed to create star" }, status: :unprocessable_entity
    end
  end
end
