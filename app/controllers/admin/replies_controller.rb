class Admin::RepliesController < AdminsController
  def edit
    @reply = Reply.find(params[:id])
  end
  
  def update
    @reply = Reply.find(params[:id])
    if @reply.update_attributes(reply_params)
      flash['success'] = "Your updates were successfully saved."
      redirect_to business_path(@reply.review.business)
    else
      flash.now['danger'] = "Your updates were not saved."
      render :edit
    end
  end
  
  def destroy
    @reply = Reply.find(params[:id])
    @reply.destroy
    redirect_to business_path(@reply.review.business)
  end
  
  private
  def reply_params
    params.require(:reply).permit(:comment)
  end
end