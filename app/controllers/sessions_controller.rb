class SessionsController < ApplicationController
    def create
      @user = User.find_by(email: params[:session][:email].downcase)
      if @user && @user.authenticate(params[:session][:password])
        session[:user_id] = @user.id
        if @user.is_a?(Admin)
          redirect_to admin_dashboard_path
        elsif @user.is_a?(Charity)
          redirect_to charity_dashboard_path
        elsif @user.is_a?(Donor)
          redirect_to donor_dashboard_path
        else
          # Handle unknown user type
          flash[:alert] = "Unknown user type"
          redirect_to root_path
        end
      else
        flash.now[:alert] = 'Invalid email/password combination'
        render 'new'
      end
    end
  
    def destroy
      session.delete(:user_id)
      @current_user = nil
      redirect_to root_path
    end
end