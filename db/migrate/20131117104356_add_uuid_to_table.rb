class AddUuidToTable < ActiveRecord::Migration
  def change
      add_column :tables, :uuid, :string
      add_index :tables, :uuid, unique: true
  end
end
