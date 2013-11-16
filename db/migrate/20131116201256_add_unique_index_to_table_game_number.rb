class AddUniqueIndexToTableGameNumber < ActiveRecord::Migration
  def change
    add_index :turns, [:table_id, :turn_number], unique: true
  end
end
