require 'spec_helper'

describe User do
  before { subject.gamertag = "nicolasjensen" }
  describe "#completeness_of" do
    context "when the user don't played the game" do
      before { @game = Game.make! }
      before { @game.stub_chain(:achievements, :empty?).and_return(false) }
      before { @game.stub_chain(:achievements, :count).and_return(50) }
      before { subject.stub_chain(:achievements, :where, :count).and_return(0) }
      it "should return 0" do
        subject.completeness_of(@game).should be_zero
      end
    end
    context "when the user have played the game and completed 50% of the achievements" do
      before { @game = Game.make! }
      before { @game.stub_chain(:achievements, :empty?).and_return(false) }
      before { @game.stub_chain(:achievements, :count).and_return(50) }
      before { subject.stub_chain(:achievements, :where, :count).and_return(25) }
      it "should return 50" do
        subject.completeness_of(@game).should be_== 50
      end
    end
  end

  describe "#update_games" do
    context "when the user have FIFA 13 and Burnout Paradise games" do
      before do
        XboxLive.stub(:games).with("nicolasjensen").and_return({
          "Data" => {
            "PlayedGames" => [
              {
                "Id" => 1161890200,
                "Title" => "FIFA 13"
              },
              {
                "Id" => 1161889798,
                "Title" => "Burnout Paradise"
              }
            ]
          }
        })
      end

      it "should find or create each game" do
        Game.should_receive(:find_or_create_by_uid).with(1161890200, :uid => 1161890200, :title => "FIFA 13", :image => nil).and_return(Game.make!)
        Game.should_receive(:find_or_create_by_uid).with(1161889798, :uid => 1161889798, :title => "Burnout Paradise", :image => nil).and_return(Game.make!)
        subject.update_games
      end

      it "should associate each game to the user" do
        Game.stub(:find_or_create_by_uid).and_return(Game.make!)
        subject.games.should_receive(:<<).twice
        subject.update_games
      end
    end
  end

  describe "#update_achievements" do
    context "when the user have Battlefield 3 game with some achievements" do
      before { subject.save }
      let(:battlefield3) { Game.make!(:uid => 1161890200, :title => "Battlefield 3") }
      before { subject.games << battlefield3 }
      before do
        XboxLive.stub(:achievements).with("nicolasjensen", 1161890200).and_return({
          "Data" => {
            "Achievements" => [
              {
                "Id" => 13,
                "Title" => "Scrap Metal",
                "Description" => "Destroy 6 enemy tanks before reaching the fort in Thunder Run",
                "GamerScore" => 25,
                "IsSecret" => "no",
                "Unlocked" => "yes"
              },
              {
                "Id" => 12,
                "Title" => "You can be my wingman anytime",
                "Description" => "Complete Going Hunting in a perfect run",
                "GamerScore" => 30,
                "IsSecret" => "no",
                "Unlocked" => "yes"
              }
            ]
          }
        })
      end

      it "should find or create each achievement" do
        Achievement.should_receive(:find_or_create_by_uid_and_game_id).with(
          13, 
          battlefield3.id,
          :uid => 13, 
          :game_id => battlefield3.id,
          :title => "Scrap Metal", 
          :description => "Destroy 6 enemy tanks before reaching the fort in Thunder Run",
          :score => 25,
          :secret => false
        ).and_return(Achievement.make!)

        Achievement.should_receive(:find_or_create_by_uid_and_game_id).with(
          12, 
          battlefield3.id,
          :uid => 12, 
          :game_id => battlefield3.id,
          :title => "You can be my wingman anytime", 
          :description => "Complete Going Hunting in a perfect run",
          :score => 30,
          :secret => false
        ).and_return(Achievement.make!)

        subject.update_achievements
      end

      it "should associate each achievement to the user" do
        Achievement.stub(:find_or_create_by_uid_and_game_id).and_return(Achievement.make!)
        subject.achievements.should_receive(:<<).twice
        subject.update_achievements
      end
    end
  end
end
