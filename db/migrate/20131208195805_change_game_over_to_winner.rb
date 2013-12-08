class ChangeGameOverToWinner < ActiveRecord::Migration
  def change
    remove_column :tables, :game_over
    add_column :tables, :winner_id, :integer
  end
end
