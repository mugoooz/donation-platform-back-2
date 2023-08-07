class CharitiesController < ApplicationController
    protect_from_forgery with: :null_session
  
    def index
      render json: Charity.all, status: :ok
    end
  
    def show
      charity = Charity.find_by(id: params[:id])
      if charity
        render json: charity, status: :ok
      else
        render json: { error: "Charity not found" }, status: :not_found
      end
    end
  
    def signup
      charity = Charity.new(charity_params)
  
      if charity.save
        token = encode_token(charity.id, charity.email)
        render json: { charity: charity, token: token }, status: :created
      else
        render json: { errors: charity.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def create
      charity = Charity.new(charity_params)
      if charity.save
        render json: charity, status: :created
      else
        render json: { errors: charity.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      charity = Charity.find_by(id: params[:id])
      if charity
        charity.update(charity_params)
        render json: charity, status: :accepted
      else
        render json: { error: "Charity not found" }, status: :not_found
      end
    end
  
    def destroy
      charity = Charity.find_by(id: params[:id])
      if charity
        charity.destroy
        head :no_content
      else
        render json: { error: 'Charity not found' }, status: :not_found
      end
    end
  
    def login
      charity = Charity.find_by(email: charity_params[:email])
      if charity && charity.authenticate(charity_params[:password])
        token = encode_token(charity.id, charity.email)
        render json: { charity: charity, token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    def logout
      remove_charity
      render json: { message: 'Logout successful' }
    end
  
    private
  
    def charity_params
      params.require(:charity).permit(:name, :location, :email, :password, :purpose)
    end
  end
  