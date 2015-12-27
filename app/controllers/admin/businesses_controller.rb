class Admin::BusinessesController < AdminsController
  before_action :require_admin
  
  def new
    @business = Business.new
  end
  
  def create
    @business = Business.new(business_params)
    if @business.save
      flash['success'] = "The business was successfully created."
      redirect_to home_path
    else
      render :new
    end
  end  
  
  private
  def business_params
    params.require(:business).permit(:name, :address, :city, :state, :url, :category_id)
  end
end