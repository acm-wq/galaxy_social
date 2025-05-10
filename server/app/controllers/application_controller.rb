class ApplicationController < ActionController::API
  JWT_KEY = Rails.application.credentials.jwt_secret || ENV['JWT_SECRET']

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = JWT.decode(header, JWT_KEY, true, algorithm: 'HS256')[0]
      @current_user = decoded
    rescue JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
