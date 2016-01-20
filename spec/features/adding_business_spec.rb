require 'spec_helper'

feature "Business is added" do  
  scenario "with valid input" do
    cat = Fabricate(:category, name: "one")
    cat2 = Fabricate(:category, name: "two")
    cat3 = Fabricate(:category, name: "three")
    cat4 = Fabricate(:category, name: "four")
    jane = Fabricate(:user)
    tom = Fabricate(:admin)
    
    sign_in(jane)
    click_link "Add A New Eatery"
    fill_in_business_form
    click_button "Submit"
    expect(page).to have_content "Business submitted and pending approval."
    visit home_path
    expect(page).not_to have_content "Hoggy's Place"
    sign_out
    
    sign_in(tom)
    visit admin_admin_panel_path
    expect(page).to have_content "Hoggy's Place"
    click_link "Approve"
    expect(page).to have_content "Business has been approved and added to index."
    visit home_path
    expect(page).to have_content "Hoggy's Place"    
  end
  
  def fill_in_business_form
    fill_in 'Name', with: "Hoggy's Place"
    fill_in 'Address', with: '123 Place Street'
    fill_in 'City', with: 'Ogden'
    fill_in 'State', with: 'Vermont'
    fill_in 'Website', with: 'www.example40.com'
    select "three", from: 'Category'
  end
end

  
