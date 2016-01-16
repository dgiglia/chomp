class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
  
  delegate :category, to: :business
    
end