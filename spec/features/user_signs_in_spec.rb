require 'spec_helper'

feature "User signs in" do
  scenario "with valid credentials" do
    sign_in

    expect(page).to have_content "You're signed in."
  end
end