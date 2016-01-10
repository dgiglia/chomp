class Admin::BusinessesController < AdminsController
  before_action :require_admin  
  
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
  
  def approve_business
    @business = Business.find(params[:id])
    @business.update_attribute(:approved, true)
    flash['success'] = "Business has been approved and added to index."
    redirect_to admin_admin_panel_path
  end

  def destroy
    @business = Business.find(params[:id])
    @business.destroy
    redirect_to admin_admin_panel_path
  end
  
  private
  def business_params
    params.require(:business).permit(:name, :address, :city, :state, :url, :category_id, :approved)
  end
end