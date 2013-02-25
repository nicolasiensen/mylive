class User < ActiveRecord::Base
  attr_accessible :gamertag
  has_and_belongs_to_many :achievements
  has_and_belongs_to_many :games

  def completeness_of game
    ((self.achievements.where(:game_id => game.id).count.to_f/game.achievements.count.to_f)*100).round
  end
end
