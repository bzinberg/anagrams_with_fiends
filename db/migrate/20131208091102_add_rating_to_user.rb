class AddRatingToUser < ActiveRecord::Migration
  def change
    add_column :users, :rating_mean, :float, default: 25.0
    add_column :users, :rating_deviation, :float, default: 25.0/3.0
  end
end
