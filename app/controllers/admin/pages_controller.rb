class Admin::PagesController < AdminsController
  before_action :require_admin
  
  def admin_panel
    @businesses = Business.where(approved: false)
    @business_ownerships = BusinessOwnership.where(approved: false)
  end
end