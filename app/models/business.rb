class Business < ActiveRecord::Base
  has_many :reviews, -> {order("created_at DESC")}, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :recommendations
  has_many :owners, through: :business_ownerships
  has_many :business_ownerships, -> { where approved: true }, dependent: :destroy
  belongs_to :category
  
  validates_presence_of :name, :city, :state
  validates_uniqueness_of :name
  
  mount_uploader :business_photo, BusinessPhotoUploader
  
  def average_rating
    return 0 if reviews.empty?
    reviews.average(:rating).round(1)
  end
  
  def self.search_by_city(search_term)
    return [] if search_term.blank?
    where("city ILIKE ?", "%#{search_term}%").order("name ASC")
  end
  
  def owned?
    owners.any?
  end
  
  def recent_reviews
    reviews.where('created_at >= ?', 1.week.ago) if reviews
  end
end