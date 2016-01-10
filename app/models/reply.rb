class Reply < ActiveRecord::Base  
  belongs_to :review
  belongs_to :user
  
  validates_presence_of :comment
end