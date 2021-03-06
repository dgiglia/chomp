class Review < ActiveRecord::Base  
  belongs_to :user
  belongs_to :business, touch: true
  has_many :replies
  
  mount_uploader :review_photo, ReviewPhotoUploader
  
  validates_presence_of :rating, :comment
end