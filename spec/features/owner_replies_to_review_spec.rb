require 'spec_helper'

feature "Owner replies to review" do  
  scenario "successfully" do
    user = Fabricate(:user)
    jane = Fabricate(:user)
    cat = Fabricate(:category)
    business = Fabricate(:business, category: cat)
    relation = Fabricate(:business_ownership, owner_id: jane.id, business_id: business.id, approved: true)
    review = Fabricate(:review, user_id: user.id, business_id: business.id)
    
    sign_in(jane)
    visit business_owner_admin_panel_path
    expect(page).to have_content "Yes"
    
    click_link business.name
    expect(page).to have_content review.comment
    
    click_link "Reply"
    expect(page).to have_content "Reply to this review"
    fill_in "Reply", with: "This is my reply."
    click_button "Submit Reply"
    expect(page).to have_content "This is my reply."
    expect(page).to have_content business.name
  end
end
