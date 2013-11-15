class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :initial_bag
      t.boolean :game_over

      t.timestamps
    end
  end
end
