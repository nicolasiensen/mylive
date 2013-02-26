class User < ActiveRecord::Base
  attr_accessible :gamertag
  has_and_belongs_to_many :achievements
  has_and_belongs_to_many :games

  def completeness_of game
    return 0 if game.achievements.empty?
    ((self.achievements.where(:game_id => game.id).count.to_f/game.achievements.count.to_f)*100).round
  end

  def update_games
    XboxLive.games(self.gamertag)["Data"]["PlayedGames"].each do |game|
      self.games << Game.find_or_create_by_uid(game["Id"], :uid => game["Id"], :title => game["Title"], :image => game["LargeBoxArt"])
    end
  end

  def update_achievements
    self.games.each do |game|
      XboxLive.achievements(self.gamertag, game.uid)["Data"]["Achievements"].each do |achievement|
        a = Achievement.find_or_create_by_uid_and_game_id(
          achievement["Id"], 
          game.id, 
          :uid => achievement["Id"], 
          :game_id => game.id, 
          :title => achievement["Title"], 
          :description => achievement["Description"],
          :score => achievement["GamerScore"],
          :secret => achievement["IsSecret"] == "yes" ? true : false
        )
        self.achievements << a if achievement["Unlocked"] == "yes"
      end
    end
  end
end
