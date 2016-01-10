class AddPhotoToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :business_photo, :string
  end
end
