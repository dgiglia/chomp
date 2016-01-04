class BusinessOwner::PagesController < BusinessOwnersController
  before_action :require_business_owner
  
  def admin_panel
  end
end