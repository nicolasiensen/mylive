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
end
