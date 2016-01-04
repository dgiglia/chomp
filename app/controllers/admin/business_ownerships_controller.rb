class Admin::BusinessOwnershipsController < AdminsController
  before_action :require_admin  
  
  def approve
    @business_ownership = BusinessOwnership.find(params[:id])
    @business_ownership.update_attribute(:approved, true)    
    AppMailer.delay.send_claim_approved_email(@business_ownership)
    flash['success'] = "Business has been approved and added to index."
    redirect_to admin_admin_panel_path
  end

  def destroy
    @business_ownership = BusinessOwnership.find(params[:id])
    @business_ownership.destroy
    redirect_to admin_admin_panel_path
  end
end