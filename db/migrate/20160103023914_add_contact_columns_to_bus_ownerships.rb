class AddContactColumnsToBusOwnerships < ActiveRecord::Migration
  def change
    add_column :business_ownerships, :contact_phone, :string
    add_column :business_ownerships, :contact_address, :text
    add_column :business_ownerships, :message, :text
    
  end
end
