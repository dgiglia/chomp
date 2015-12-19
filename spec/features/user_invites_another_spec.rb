require 'spec_helper'

feature "User invites friend" do
  scenario "user successfully invites friend and invitation is accepted" do
    user = Fabricate(:user)
    sign_in(user)
    invite_another_user    
    another_user_accepts_invitation
    another_user_signs_in     
    another_user_should_follow(user)
    another_user_should_be_followed_by(user)
    clear_email
  end
  
  def invite_another_user
    click_link "My Connections"
    click_link "Invite Friend"
    expect(page).to have_content ("Invite a friend to join chOMP!")
    fill_in "invitation[recipient_name]", with: "Sam"
    fill_in "Friend's Email Address", with: "sam@example.com"
    fill_in "Invitation Message", with: "Please join me."
    click_button "Send Invitation"
    sign_out
  end
  
  def another_user_accepts_invitation
    open_email "sam@example.com"
    current_email.click_link "Accept this invitation"
    
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Sam"
    fill_in "City", with: "Oxford"
    fill_in "State", with: "Minnesota"
    click_button "Register"
  end
  
  def another_user_signs_in
    expect(page).to have_content("Your profile was successfully created.")
    fill_in "Email Address", with: "sam@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end
  
  def another_user_should_follow(user)
    click_link "My Profile"
    expect(page).to have_content user.name
    sign_out
  end
  
  def another_user_should_be_followed_by(user)
    sign_in(user)
    click_link "My Profile"
    expect(page).to have_content("Sam")
  end
end