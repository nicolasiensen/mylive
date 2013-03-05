Given /^there is an user$/ do
  @user = User.make!
end

When /^I go to "(.*?)"$/ do |arg1|
  visit(user_path(@user)) if arg1 == "this user page"
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Given /^this user completed "(.*?)" achievements out of "(.*?)" of "(.*?)"$/ do |arg1, arg2, arg3|
  game = Game.make! :title => arg3
  @user.games << game
  arg2.to_i.times { game.achievements << Achievement.make! }
  arg1.to_i.times { |i| @user.achievements << game.achievements[i] }
end

Then /^I should see "(.*?)" as the (\d+)(st|nd|rd) game with "(.*?)" percent completed$/ do |arg1, arg2, arg3, arg4|
  page.should have_css(".games .game:nth-child(#{arg2.to_i + 1}) h2", :text => arg1)
  page.should have_css(".games .game:nth-child(#{arg2.to_i + 1}) span.game_completeness", :text => arg4)
end

Then /^I should not see "(.*?)"$/ do |arg1|
  page.should_not have_content(arg1)
end
