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
  
  def edit
    @business = Business.find(params[:id])
  end
  
  def update
    @business = Business.find(params[:id])
    if @business.update_attributes(business_params)
      flash['success'] = "Your updates were successfully saved."
      redirect_to business_path(@business)
    else
      flash.now['danger'] = "Your updates were not saved."
      render :edit
    end
  end
  
  def destroy
    @business = Business.find(params[:id])
    @business.destroy
    redirect_to home_path
  end
  
  private
  def business_params
    params.require(:business).permit(:name, :address, :city, :state, :url, :category_id)
  end
end