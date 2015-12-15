require 'spec_helper'

feature "User favorites business" do    
  scenario "add it to favorites page" do 
    cat = Fabricate(:category)
    Fabricate(:business, name: "Funville", category: cat)
    
    
    sign_in    
    click_link "Funville"
    expect(page).to have_content "Favorite"
    
    click_on "Favorite"
    visit favorites_path
    
    expect(page).to have_content "Funville"
    
    unfavorite_business
    visit favorites_path
    expect(page).not_to have_content "Funville"    
  end
  
  def unfavorite_business
    find("a[data-method='delete']").click
  end
end