class BusinessOwnershipsController < ApplicationController
  before_action :require_user
  
  def new
    @business = Business.find(params[:business_id])
    @business_ownership = BusinessOwnership.new
  end
  
  def create
    @business = Business.find(params[:business_id])
    @business_ownership = BusinessOwnership.new(business_ownership_params.merge!(business_id: @business.id, owner_id: current_user.id))
    if @business_ownership.save
      AppMailer.delay.send_claim_submitted_email(@business_ownership)
      flash['success'] = "Your claim has been submitted."
      redirect_to business_path(@business)
    else
      flash.now['danger'] = "Your claim was not submitted."
      render :new
    end
  end
  
  private
  def business_ownership_params
    params.require(:business_ownership).permit(:contact_phone, :contact_address, :message, :owner_id, :business_id)
  end
end