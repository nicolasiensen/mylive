Feature: view my games ordered by completeness
  
  Scenario: when I have no game
    Given there is an user
    When I go to "this user page"
    Then I should see "No game found"

  Scenario: when I have three games
    Given there is an user
    And this user completed "19" achievements out of "90" of "Burnout Paradise"
    And this user completed "28" achievements out of "58" of "Battlefield 3"
    And this user completed "15" achievements out of "48" of "FIFA 13"
    When I go to "this user page"
    Then I should see "Battlefield 3" as the 1st game with "48" percent completed
    And I should see "FIFA 13" as the 2nd game with "31" percent completed
    And I should see "Burnout Paradise" as the 3rd game with "21" percent completed
