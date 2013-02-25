class Game < ActiveRecord::Base
  attr_accessible :image, :title, :uid
  has_many :achievements

  def self.by_completeness user
    user.games.order("
      CASE WHEN (SELECT count(*) FROM achievements a WHERE a.game_id = games.id) = 0 THEN 0 ELSE
      (SELECT count(DISTINCT a.id)
        FROM 
          achievements_users au 
          JOIN achievements a ON a.id = au.achievement_id  
        WHERE a.game_id = games.id AND au.user_id = #{user.id})::numeric / 
      (SELECT count(*) 
        FROM achievements a 
        WHERE a.game_id = games.id) END DESC
    ")
  end
end
