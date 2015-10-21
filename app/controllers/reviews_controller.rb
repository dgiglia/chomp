class ReviewsController < ApplicationController
  before_action :require_user
  
  def index
    @reviews = Review.all
  end
  
  def create
    @business = Business.find(params[:business_id])
    review = @business.reviews.create(review_params.merge!(user: current_user))
    if review.save
      redirect_to @business
    else
      @reviews = @business.reviews.reload
      render "businesses/show"
    end
  end
  
  private
  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end