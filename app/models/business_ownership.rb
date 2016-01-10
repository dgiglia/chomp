class BusinessOwnership < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :business
  
  validates_presence_of :contact_phone, :contact_address
end