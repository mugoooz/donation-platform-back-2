class SessionsController < ApplicationController
  def signup
    user_type = params[:user][:user_type].downcase
    if valid_user_type?(user_type)
      @user = user_type.capitalize.constantize.new(user_params)

      if @user.save
        token = encode_token(@user.id, @user.email, user_type)
        render json: { user: @user, token: token }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid user type' }, status: :unprocessable_entity
    end
  end

  def create
    user_type = params[:session][:user_type].downcase
    if valid_user_type?(user_type)
      @user = user_type.capitalize.constantize.find_by(email: params[:session][:email].downcase)

      if @user && @user.authenticate(params[:session][:password])
        token = encode_token(@user.id, @user.email, user_type)
        render json: { user: @user, token: token }, status: :ok
      else
        render json: { error: 'Invalid email/password combination' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid user type' }, status: :unprocessable_entity
    end
  end

  def destroy
    remove_user
    render json: { message: 'Logout successful' }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def valid_user_type?(user_type)
    %w(admin charity donor).include?(user_type)
  end
end
