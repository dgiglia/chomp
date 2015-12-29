class Admin::UsersController < AdminsController

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to home_path
  end

end