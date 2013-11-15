class AddTableIdToTurn < ActiveRecord::Migration
  def change
    add_column :turns, :table_id, :integer
  end
end
