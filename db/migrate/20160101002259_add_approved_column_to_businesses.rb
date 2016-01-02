class AddApprovedColumnToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :approved, :boolean, null: false, default: false
  end
end
