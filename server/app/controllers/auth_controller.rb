class AuthController < ApplicationController
  # POST /register
  def register
    name = params[:name]
    password = params[:password]

    if name.blank? || password.blank? || password.length < 6
      return render json: { error: 'Invalid name or password' }, status: :unprocessable_entity
    end

    user = User.new("name" => name, "password" => password)
    user.save

    token = generate_token(user)

    render json: { token: token, key: user.key }, status: :created
  end

  # POST /login
  def login
    key = params[:key]
    password = params[:password]

    user = User.authenticate(key, password)

    if user
      token = generate_token(user)
      render json: { token: token, key: user.key }
    else
      render json: { error: 'Invalid key or password' }, status: :unauthorized
    end
  end

  private

  def generate_token(user)
    payload = {
      key: user.key,
      name: user.name,
      exp: 1.hour.from_now.to_i
    }

    JWT.encode(payload, JWT_KEY, 'HS256')
  end
end
