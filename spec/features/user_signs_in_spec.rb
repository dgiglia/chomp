require 'spec_helper'

feature "User signs in" do
  scenario "with valid credentials" do
    jim = Fabricate(:user)

    sign_in(jim)

    expect(page).to have_content "You're signed in."
  end
end