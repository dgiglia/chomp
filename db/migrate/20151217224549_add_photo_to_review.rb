class AddPhotoToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :review_photo, :string
  end
end
