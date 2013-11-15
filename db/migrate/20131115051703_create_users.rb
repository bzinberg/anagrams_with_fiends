class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.integer :high_score
      t.integer :table_id
      t.integer :flip_request_turn_number

      t.timestamps
    end
  end
end
