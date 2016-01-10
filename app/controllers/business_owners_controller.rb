class BusinessOwnersController < ApplicationController 
  before_action :require_user
  before_action :require_business_owner
  
  private
  def require_business_owner
    if !current_user.business_owner?
      flash['danger'] = "You are not authorized to do that."
      redirect_to home_path
    end
  end
end