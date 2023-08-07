class SessionsController < ApplicationController
  protect_from_forgery with: :exception

  def create
    # Authenticate user based on credentials (email and password)
    user = User.authenticate(params[:email], params[:password])

    if user
      token = encode_token(user.id, user.email, user.user_type)
      save_user(user.id, user.user_type)
      render json: { user: user, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    remove_user
    render json: { message: 'Logout successful' }
  end
end
