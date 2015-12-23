class RecommendationsController < ApplicationController
  before_action :require_user
  
  def new
    @business = Business.find(params[:business_id])
    @recommendation = Recommendation.new
  end
  
  def create
    @business = Business.find(params[:business_id])
    @recommendation = Recommendation.new(recommendation_params.merge!(business_id: @business.id, sender_id: current_user.id))
    if @recommendation.save
      AppMailer.delay.send_recommendation_email(@recommendation)
      flash['success'] = "A recommendation has been sent to #{@recommendation.recipient_name}."
      redirect_to business_path(@business)
    else
      flash.now['danger'] = "Your recommendation was not sent."
      render :new
    end
  end
  
  private
  def recommendation_params
    params.require(:recommendation).permit(:recipient_name, :recipient_email, :message, :business_id, :sender_id)
  end
end