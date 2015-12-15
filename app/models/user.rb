class User < ActiveRecord::Base
  has_many :reviews
  has_many :favorites
  has_secure_password validations: false
  
  validates_presence_of :email, :password, :name, :city, :state
  validates_uniqueness_of :email 
end