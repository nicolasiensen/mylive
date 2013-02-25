class CreateAchievementsUsers < ActiveRecord::Migration
  def change
    create_table :achievements_users do |t|
      t.integer :user_id
      t.integer :achievement_id
    end
  end
end
