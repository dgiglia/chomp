class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.delay.send_welcome_email(@user)
      handle_invitation
      flash['success'] = "Your profile was successfully created."
      redirect_to sign_in_path
    else
      render :new
    end
  end
  
  def show
    @user = UserDecorator.decorate(User.find(params[:id]))
  end
  
  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :password, :email, :city, :state, :avatar)
  end
  
  def handle_invitation
    if params[:invitation_token].present?
      @invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(@invitation.inviter)
      @invitation.inviter.follow(@user)   
      AppMailer.delay.send_inviter_email_confirming_acceptance(@invitation)
      @invitation.update_column(:token, nil)
    end
  end
end