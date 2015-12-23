class Recommendation < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :business
  
  validates_presence_of :recipient_email, :recipient_name
end