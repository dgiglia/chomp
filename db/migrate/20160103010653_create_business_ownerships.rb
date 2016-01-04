class CreateBusinessOwnerships < ActiveRecord::Migration
  def change
    create_table :business_ownerships do |t|
      t.integer :owner_id
      t.integer :business_id
      t.boolean :approved, default: false, null: false
      
      t.timestamps
    end
  end
end
