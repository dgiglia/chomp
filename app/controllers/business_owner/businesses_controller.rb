class BusinessOwner::BusinessesController < BusinessOwnersController
  before_action :require_business_owner  
  
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
  
  private
  def business_params
    params.require(:business).permit(:name, :address, :city, :state, :url, :category_id, :business_photo)
  end
end