Feature: UserControll
  In order to be in a club
  As a normal user
  I want to be first accepted before member of Club

  Scenario: Test definitions
    Given user 1 with a club 'Testverein'
    And user 2 without clubs
    Then user 1 should have one club
    And user 2 has no club

  Scenario: Adding a club to yours
    Given user 1 without clubs
    And user 1 logges in
    And there is 1 club
    When I add a club
    Then should this club be a pending club

  Scenario: Someone wants to join my club
    Given user 1 with a club 'Testverein'
    And user 2 without clubs
    And user 2 logges in
    When I add the club 'Testverein'
    And I log out
    And user 2 logges in
    And I go to club 'Testverein'
    Then user 1 should be shown as pending