class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :signed_in?, :admin?
  
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  
  def admin?
    current_user.admin?
  end
    
  def signed_in?
    !!current_user
  end
  
  def require_user
    access_denied unless signed_in?
  end
  
  def access_denied
    flash['danger'] = "You can't do that without an account with the proper permissions! Please sign in."
    redirect_to root_path
  end
end
