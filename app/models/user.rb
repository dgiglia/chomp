class User < ActiveRecord::Base
  has_many :reviews
  has_many :favorites
  has_many :following_connections, class_name: "Connection", foreign_key: "follower_id"
  has_many :leading_connections, class_name: "Connection", foreign_key: "leader_id"
  has_secure_password validations: false
  
  validates_presence_of :email, :password, :name, :city, :state
  validates_uniqueness_of :email 
  
  def can_follow?(another_user)
    !(self.follows?(another_user) || another_user == self)
  end
  
  def follows?(another_user)
    following_connections.map(&:leader).include?(another_user)
  end
end