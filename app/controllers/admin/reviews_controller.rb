class Admin::ReviewsController < AdminsController
  def edit
    @review = Review.find(params[:id])
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(review_params)
      flash['success'] = "Your updates were successfully saved."
      redirect_to business_path(@review.business)
    else
      flash.now['danger'] = "Your updates were not saved."
      render :edit
    end
  end
  
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to business_path(@review.business)
  end
  
  private
  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end