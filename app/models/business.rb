class Business < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["chomp", Rails.env].join'_'
  
  has_many :reviews, -> {order("created_at DESC")}, dependent: :destroy
  has_many :favorites, -> {order("created_at DESC")}, dependent: :destroy
  has_many :recommendations
  has_many :owners, through: :business_ownerships
  has_many :business_ownerships, -> { where approved: true }, dependent: :destroy
  belongs_to :category
  
  validates_presence_of :name, :city, :state
  validates_uniqueness_of :name
  
  mount_uploader :business_photo, BusinessPhotoUploader
  
  def average_rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end
  
  def owned?
    owners.any?
  end
  
  def recent_reviews
    reviews.where('created_at >= ?', 1.week.ago) if reviews
  end
  
  def self.search_by_city(search_term)
    return [] if search_term.blank?
    where("city ILIKE ?", "%#{search_term}%").order("name ASC")
  end
  
  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ['name^100', 'city^75', 'state^50'],
          operator: 'and'
        }
      }
    }
    if query.present? && options[:reviews]
      search_definition[:query][:multi_match][:fields] << 'reviews.comment'
    end
    
    if options[:average_rating_from].present? || options[:average_rating_to].present?
      search_definition[:filter] = {
        range: {
          average_rating: {
            gte: (options[:average_rating_from] if options[:average_rating_from].present?),
            lte: (options[:average_rating_to] if options[:average_rating_to].present?)
          }
        }
      }
    end
    
    __elasticsearch__.search(search_definition)
  end
  
  def as_indexed_json(options={})
    as_json(
      methods: [:average_rating],
      only: [:name, :city, :state],
      include: {
        reviews: { only: [:comment] }
      }      
    )
  end
end