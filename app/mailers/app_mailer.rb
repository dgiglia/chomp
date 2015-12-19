class AppMailer < ActionMailer::Base
  default from: "info@chomp.com"
  
  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to chOMP!"
  end
  
  def send_inviter_email_confirming_acceptance(invitation)
    @invitation = invitation
    mail to: invitation.inviter.email, subject: "Your friend has joined chOMP!"
  end
  
  def send_forgot_password(user)
    @user = user
    mail to: user.email, subject: "Please reset your password."
  end
  
  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: "Invitation to join chOMP."
  end
  
  def send_recommendation_email(recommendation)
    @recommendation = recommendation
    mail to: recommendation.recipient_email, subject: "Recommendation on chOMP."
  end
end