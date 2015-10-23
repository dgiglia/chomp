require 'spec_helper'

feature "User views another user's profile" do
  scenario "with valid credentials" do
    fig = Fabricate(:user, name: "fig")
    bus = Fabricate(:business, name: "Toads")
    rev = Fabricate(:review, user: fig, business: bus)
    
    sign_in
    visit reviews_path
    click_link('fig')
    expect(page).to have_content "chOMPing since"
  end
end