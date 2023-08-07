class AdminsController < ApplicationController
    protect_from_forgery with: :null_session
  
    def index
      render json: Admin.all, status: :ok
    end
  
    def show
      admin = Admin.find_by(id: params[:id])
      if admin
        render json: admin, status: :ok
      else
        render json: { error: "Admin not found" }, status: :not_found
      end
    end
  
    def signup
      admin = Admin.new(admin_params)
  
      if admin.save
        token = encode_token(admin.id, admin.email)
        render json: { admin: admin, token: token }, status: :created
      else
        render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def create
      admin = Admin.new(admin_params)
      if admin.save
        render json: admin, status: :created
      else
        render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      admin = Admin.find_by(id: params[:id])
      if admin
        admin.update(admin_params)
        render json: admin, status: :accepted
      else
        render json: { error: "Admin not found" }, status: :not_found
      end
    end
  
    def destroy
      admin = Admin.find_by(id: params[:id])
      if admin
        admin.destroy
        head :no_content
      else
        render json: { error: 'Admin not found' }, status: :not_found
      end
    end
  
    def login
      admin = Admin.find_by(email: admin_params[:email])
      if admin && admin.authenticate(admin_params[:password])
        token = encode_token(admin.id, admin.email)
        render json: { admin: admin, token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    def logout
      remove_admin
      render json: { message: 'Logout successful' }
    end
  
    private
  
    def admin_params
      params.require(:admin).permit(:username, :password)
    end
  end
  
