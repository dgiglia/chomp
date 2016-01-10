class BusinessOwner::PagesController < BusinessOwnersController
  before_action :require_business_owner
  
  def admin_panel
    @businesses = current_user.businesses
  end
end