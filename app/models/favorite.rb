class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
  
  delegate :category, to: :business
  delegate :name, to: :business, prefix: :business
  
  def category_name
    category.name
  end
  
  def rating
    review.rating if review
  end
  
  def rating=(new_rating)    
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, business: business, rating: new_rating)
      review.save(validate: false)
    end
  end
  
  private
  def review
    @review ||= Review.find_by(user_id: user.id, business_id: business.id)
  end
    
end