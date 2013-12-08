class AddLastLobbyPollToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_lobby_poll, :integer
  end
end
