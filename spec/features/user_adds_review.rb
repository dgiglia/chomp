require 'spec_helper'

feature "User adds review" do
  business = Fabricate(:business, name: "ABC")
  scenario "with valid input" do
    sign_in
    click_link "ABC"
    fill_in_review_form
    click_button "Add"

    expect(page).to have_content "Your review was successfully created."
  end
  
  def fill_in_review_form
    fill_in 'Comments', with: 'This is great.'
    select '3 Bites', from: 'Rating'
  end
end

