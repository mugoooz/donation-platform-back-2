class DonorsController < ApplicationController

    def index
        @donors = Donor.all
      end

    def show
        @donor = Donor.find(params[:id])
      end

    def new
        @donor = Donor.new
      end

    def create
        @donor = Donor.new(donor_params)
        if @donor.save
          redirect_to @donor
        else
          render :new
        end
      end

    def edit
        @donor = Donor.find(params[:id])
      end

    def update
        @donor = Donor.find(params[:id])
        if @donor.update(donor_params)
          redirect_to @donor
        else
          render :edit
        end
      end
      
    def destroy
        @donor = Donor.find(params[:id])
        @donor.destroy
        redirect_to donors_path
      end
    
      def dashboard
        @donor = Donor.find(params[:id])
        @donations = @donor.donations 
      end
      
    private

    def donor_params
        params.require(:donor).permit(:name, :email, :password, :phone_number)
      end
    end
end