require 'spec_helper'

feature "Owner claims business" do  
  scenario "and is accepted by admin" do
    user = Fabricate(:user, email: "bunny@example.com")
    admin = Fabricate(:admin)
    cat = Fabricate(:category)
    business = Fabricate(:business, category: cat)
    
    sign_in(user)
    visit business_path(business)
    click_link "Claim This Business"
    expect(page).to have_content "Owner Verification"
    fill_in_owner_form    
    open_email "bunny@example.com"
    expect(current_email).to have_content "Your claim to this business is being reviewed."
    sign_out
    
    sign_in(admin)
    visit admin_admin_panel_path
    expect(page).to have_content (business.name)
    expect(page).to have_content (user.name)
    click_link "Approve"
    sign_out 
    
    open_email "bunny@example.com"
    expect(current_email).to have_content "Your claim for #{business.name} has been approved."
    
    sign_in(user)
    expect(page).to have_content "Owner Admin Panel"
    clear_email
  end
  
  def fill_in_owner_form
    fill_in "Contact Phone", with: "1234567890"
    fill_in "Contact Address", with: "123 Street Place, Bully Hill, VA 12345"
    fill_in "Claim Message", with: "I have owned this business for 20 years. My tax verification code is : TX134456576. Please contact me for further verification. Thanks."
    click_button "Make Claim"
  end
end