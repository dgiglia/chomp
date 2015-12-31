class Admin::CategoriesController < AdminsController
  before_action :require_admin
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    if @category.save
      flash['success'] = "The category was successfully created."
      redirect_to home_path
    else
      render :new
    end
  end
  
  private
  def category_params
    params.require(:category).permit(:name)
  end
end