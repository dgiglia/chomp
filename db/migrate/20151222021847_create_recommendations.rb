class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :recipient_name
      t.string :recipient_email
      t.text :message
      t.integer :sender_id
      t.integer :business_id
      
      t.timestamps
    end
  end
end
