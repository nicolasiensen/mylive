class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer :game_id
      t.string :uid
      t.string :title
      t.text :description
      t.integer :score
      t.boolean :secret

      t.timestamps
    end
  end
end
