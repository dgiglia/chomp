require 'spec_helper'

feature "User uses search bar" do
  scenario "with valid credentials" do
    bus = Fabricate(:business, name: "Winter", city: "Chicago")
    
    sign_in
    fill_in(:search_term, with: 'chicago')
    click_button("Go!")
    expect(page).to have_content "Winter"
  end
end