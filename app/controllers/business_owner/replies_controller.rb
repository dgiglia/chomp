class BusinessOwner::RepliesController < BusinessOwnersController
  before_action :require_business_owner
  
  def new
    @review = Review.find_by(params[:id])
    @reply = Reply.new
  end
  
  def create
    @review = Review.find_by(params[:id])
    reply = Reply.create(reply_params.merge!(user_id: current_user.id, review_id: @review.id))
    if reply.save
      flash['success'] = "Your reply was successfully created."
      redirect_to business_path(@review.business)
    else
      flash.now['danger'] = "Your reply was not submitted."
      render :new
    end
  end
  
  private
  def reply_params
    params.require(:reply).permit(:comment)
  end
end