class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.string :image
      t.string :uid

      t.timestamps
    end
  end
end
