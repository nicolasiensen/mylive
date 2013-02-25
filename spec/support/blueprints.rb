require 'machinist/active_record'

User.blueprint do
  gamertag { "nicolasjensen" }
end

Game.blueprint do
  title { "FIFA 13" }
  image { "http://download.xbox.com/content/images/66acd000-77fe-1000-9115-d80245410998/1033/boxartlg.jpg" }
  uid   { "1161890200" }
end

Achievement.blueprint do
  uid         { "13" }
  game        { Game.make! }
  title       { "Scrap Metal" }
  description { "Destroy 6 enemy tanks before reaching the fort in Thunder Run" }
  score       { 25 }
  secret      { false }
end
