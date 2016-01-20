require 'spec_helper'

feature "User recommends business" do
  scenario "user recommends business to friend" do
    user = Fabricate(:user)
    @friend = Fabricate(:user, email: "holly@example.com")
    cat = Fabricate(:category)
    @business = Fabricate(:business, category: cat)
    
    sign_in(user)
    recommend(@business)
    sign_out
    
    friend_follows_recommendation
  
    clear_email
  end
  
  def recommend(business)
    click_link business.name
    click_link "Recommend"
    expect(page).to have_content ("Recommend #{business.name}")
    fill_in "Friend's Name", with: @friend.name
    fill_in "Friend's Email Address", with: @friend.email
    fill_in "Recommendation Message", with: "Check this place out. It's great!"
    click_button "Send Recommendation"
  end
  
  def friend_follows_recommendation
    open_email "holly@example.com"
    current_email.click_link @business.name
    expect(page).to have_content @business.url
  end
end