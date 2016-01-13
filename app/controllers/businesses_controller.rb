class BusinessesController < ApplicationController
  before_action :require_user, only: [:new, :create]
  
  def new
    @business = Business.new
  end
  
  def index
    @businesses = Business.where(approved: true).sort_by(&:name)
  end
  
  def show
    @business = BusinessDecorator.decorate(Business.find(params[:id]))
    @reviews = @business.reviews
  end
  
  def create
    @business = Business.new(business_params)
    if @business.save
      flash['success'] = "Business submitted and pending approval."
      redirect_to home_path
    else
      render :new
    end
  end
  
  def search
    @results = Business.search_by_city(params[:search_term])
  end  
  
  def advanced_search
    options = {
      reviews: params[:reviews],
      average_rating_from: params[:average_rating_from],
      average_rating_to: params[:average_rating_to]
    }
    if params[:query]
      @businesses = Business.search(params[:query], options).records.to_a
    else
      @businesses = []
    end  
  end
  
  private
  def business_params
    params.require(:business).permit(:name, :address, :city, :state, :url, :category_id)
  end
end