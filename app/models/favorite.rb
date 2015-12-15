class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
  
  delegate :category, to: :business
  delegate :name, to: :business, prefix: :business
  
  def category_name
    category.name
  end
    
end