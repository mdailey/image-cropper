Feature: Project

  In order to crop images of project, I need project

  @javascript
  Scenario: Add a project

  An uploader should be able to add a project

    Given I am an uploader
    And I am signed in
    When I visit the project page
    Then I should see a "New Project" link
    When I click the "New Project" link
    Then I should see a project form
    When I submit the project information
    Then I should see the project information
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Edit a project

  An uploader should be able to edit a project

    Given I am an uploader
    And I am signed in
    And there is 1 project
    When I visit the project page
    Then I should see the project in the list
    When I click the edit link in the project list
    Then I should see a project form
    When I submit the project information
    Then I should see the project information
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form
