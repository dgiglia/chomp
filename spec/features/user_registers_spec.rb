require 'spec_helper'

feature 'User Registers' do
  scenario 'with valid input' do

    visit register_path
    fill_in_registration_form
    click_button "Register"

    expect(page).to have_content "Your profile was successfully created."
  end

  def fill_in_registration_form
    fill_in('Email', with: 'jimmy@example.com')
    fill_in('Password', with: 'password')
    fill_in('Name', with: 'Jimmy Jones')
    fill_in('City', with: 'Vanegen')
    fill_in('State', with: 'ND')
  end
end