class AlterUidColumnOfGame < ActiveRecord::Migration
  def up
    remove_column :games, :uid
    add_column :games, :uid, :integer
  end

  def down
    remove_column :games, :uid
    add_column :games, :uid, :string
  end
end
