class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.string :type
      t.integer :turn_number
      t.integer :changed_turn_id
      t.integer :doer_user_id
      t.string :word

      t.timestamps
    end
  end
end
