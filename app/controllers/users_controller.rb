class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.delay.send_welcome_email(@user)
      flash['success'] = "Your profile was successfully created."
      redirect_to sign_in_path
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :password, :email, :city, :state, :avatar)
  end
end