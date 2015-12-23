class FavoritesController < ApplicationController
  before_action :require_user
  
  def index
    @favorites = current_user.favorites
  end
  
  def create
    @business = Business.find(params[:business_id])
    Favorite.create(business: @business, user: current_user) unless favorite_exists?
    redirect_to favorites_path
  end
  
  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy if favorite.user == current_user
    redirect_to favorites_path
  end
  
  private
  def favorite_exists?
    current_user.favorites.map(&:business).include?(@business)
  end
end