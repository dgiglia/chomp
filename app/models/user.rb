class User < ActiveRecord::Base
  include Tokenable
  
  has_many :reviews, -> {order("created_at DESC")}, dependent: :destroy
  has_many :favorites, -> {order("created_at DESC")}, dependent: :destroy
  has_many :recommendations, foreign_key: "sender_id"
  has_many :following_connections, -> {order("created_at DESC")}, class_name: "Connection", foreign_key: "follower_id", dependent: :destroy
  has_many :leading_connections, -> {order("created_at DESC")}, class_name: "Connection", foreign_key: "leader_id", dependent: :destroy
  has_secure_password validations: false
  
  validates_presence_of :email, :password, :name, :city, :state
  validates_uniqueness_of :email 
  
  def follow(another_user)
    following_connections.create(leader: another_user) if can_follow?(another_user)
  end
  
  def can_follow?(another_user)
    !(self.follows?(another_user) || another_user == self)
  end
  
  def follows?(another_user)
    following_connections.map(&:leader).include?(another_user)
  end
end