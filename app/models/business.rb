class Business < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join'_'
  
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
  
  def as_indexed_json(options={})
    as_json(only: [:name, :city, :state])
  end
  
  def self.search(query)
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: [:name, :city, :state],
          operator: "and"
        }
      }
    }
    __elasticsearch__.search(search_definition)
  end
  
  def owned?
    owners.any?
  end
  
  def recent_reviews
    reviews.where('created_at >= ?', 1.week.ago) if reviews
  end
end