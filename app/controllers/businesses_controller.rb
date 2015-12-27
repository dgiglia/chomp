class BusinessesController < ApplicationController
  
#   def new
#     @business = Business.new
#   end
  
  def index
    @businesses = Business.all.sort_by(&:name)
  end
  
  def show
    @business = Business.find(params[:id])
    @reviews = @business.reviews
  end
  
#   def create
#     @business = Business.new(business_params)
#     if @business.save
#       flash['success'] = "The business was successfully created."
#       redirect_to home_path
#     else
#       render :new
#     end
#   end
  
  def search
    @results = Business.search_by_city(params[:search_term])
  end  
  
#   private
#   def business_params
#     params.require(:business).permit(:name, :address, :city, :state, :url, :category_id)
#   end
end