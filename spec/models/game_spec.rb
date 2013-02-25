require 'spec_helper'

describe Game do
  describe "#games_by_completeness" do
    let(:user)  { User.make! }
    let(:game1) { Game.make! }
    let(:game2) { Game.make! }
    let(:game3) { Game.make! }
    before { user.games << game1 }
    before { user.games << game2 }
    before { user.games << game3 }
    before { 40.times { Achievement.make! :game => game1 } }
    before { 50.times { Achievement.make! :game => game2 } }
    before { 60.times { Achievement.make! :game => game3 } }
    before { 5.times { |i| user.achievements << game1.achievements[i] } }
    before { 45.times { |i| user.achievements << game2.achievements[i] } }
    before { 50.times { |i| user.achievements << game3.achievements[i] } }
    it "should return games ordered by completeness" do
      Game.by_completeness(user).should be_== [game2, game3, game1]
    end
  end
end
