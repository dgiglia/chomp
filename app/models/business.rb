class Business < ActiveRecord::Base
  has_many :reviews
  belongs_to :category
  
  validates_presence_of :name, :city, :state
end