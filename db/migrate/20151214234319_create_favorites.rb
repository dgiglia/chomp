class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer  "business_id"
      t.integer  "user_id"
      t.timestamps
    end
  end
end
