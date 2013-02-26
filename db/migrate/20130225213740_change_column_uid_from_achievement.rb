class ChangeColumnUidFromAchievement < ActiveRecord::Migration
  def up
    remove_column :achievements, :uid
    add_column :achievements, :uid, :integer
  end

  def down
    remove_column :achievements, :uid
    add_column :achievements, :uid, :string
  end
end
