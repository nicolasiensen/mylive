require 'spec_helper'

describe User do
  describe "#completeness_of" do
    context "when the user don't played the game" do
      before { @game = Game.make! }
      before { @game.stub_chain(:achievements, :count).and_return(50) }
      before { subject.stub_chain(:achievements, :where, :count).and_return(0) }
      it "should return 0" do
        subject.completeness_of(@game).should be_zero
      end
    end
    context "when the user have played the game and completed 50% of the achievements" do
      before { @game = Game.make! }
      before { @game.stub_chain(:achievements, :count).and_return(50) }
      before { subject.stub_chain(:achievements, :where, :count).and_return(25) }
      it "should return 50" do
        subject.completeness_of(@game).should be_== 50
      end
    end
  end

  describe "#update_games" do
    context "when there are FIFA 13 and Burnout Paradise games" do
      before do
        XboxLive.stub(:games).with("nicolasjensen").and_return({
          "Data" => {
            "PlayedGames" => [
              {
                "ID" => 1161890200,
                "Title" => "FIFA 13"
              },
              {
                "ID" => 1161889798,
                "Title" => "Burnout Paradise"
              }
            ]
          }
        })
      end
      before { subject.gamertag = "nicolasjensen" }

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
end
