require 'spec_helper'

feature "User adds business" do  
  scenario "with valid input" do
    cat = Fabricate(:category, name: "one")
    cat2 = Fabricate(:category, name: "two")
    cat3 = Fabricate(:category, name: "three")
    cat4 = Fabricate(:category, name: "four")
    
    sign_in
    click_link "Add A New Eatery"
    fill_in_business_form
    click_button "Add"

    expect(page).to have_content "The business was successfully created."
  end
end

def fill_in_business_form
  fill_in('Name', :with => 'Jim')
  fill_in('Address', :with => '123 Place Street')
  fill_in('City', :with => 'Ogden')
  fill_in('State', :with => 'Vermont')
  fill_in('Website', :with => 'www.example40.com')
  select("three", :from => 'Category')
end