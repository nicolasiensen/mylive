class Achievement < ActiveRecord::Base
  attr_accessible :description, :game_id, :score, :secret, :title, :uid
  belongs_to :game
end
