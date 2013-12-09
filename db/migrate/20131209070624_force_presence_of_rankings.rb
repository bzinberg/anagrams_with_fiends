class ForcePresenceOfRankings < ActiveRecord::Migration
  def change
    change_column :users, :high_score, :integer, null: false, default: 0
  end
end
