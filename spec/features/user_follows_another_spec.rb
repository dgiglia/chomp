require 'spec_helper'

feature "user follows and unfollows" do
  scenario "user adds and removes another to connections list" do
    leader = Fabricate(:user)
    cat = Fabricate(:category)
    business = Fabricate(:business, category: cat)
    Fabricate(:review, user: leader, business: business)
    
    sign_in
    visit home_path
    click_link business.name
    click_link leader.name
    click_link "Follow Me"
    visit connections_path
    expect(page).to have_content(leader.name)
    
    unfollow(leader) 
    visit connections_path
    expect(page).not_to have_content(leader.name)        
  end
  
  def unfollow(user)
    find("a[data-method='delete']").click
  end

end