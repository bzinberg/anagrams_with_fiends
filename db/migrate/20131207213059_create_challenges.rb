class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :challenger_id
      t.integer :challengee_id
      t.boolean :accepted

      t.timestamps
    end
  end
end
