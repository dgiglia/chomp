class Business < ActiveRecord::Base
  has_many :reviews, -> {order("created_at DESC")}
  has_many :favorites
  belongs_to :category
  
  validates_presence_of :name, :city, :state
  validates_uniqueness_of :name
  
  def average_rating
    return 0 if reviews.empty?
    reviews.average(:rating).round(1)
  end
  
  def self.search_by_city(search_term)
    return [] if search_term.blank?
    where("city ILIKE ?", "%#{search_term}%").order("name ASC")
  end
end