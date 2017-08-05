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

  @javascript
  Scenario: Assign project a user

  An admin/uploader should be able to assign project to a user

    Given I am an admin
    And I am signed in
    And there is 1 user
    And I "activate" the user
    And there is 1 project
    When I visit the project page
    Then I should see the project in the list
    When I click the assign link in the project list
    Then I should see the user in the list
    When I click checkbox to assign project
    Then the project should be assigned
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Unassign project a user

  An admin/uploader should be able to unassign project to a user

    Given I am an admin
    And I am signed in
    And there is 1 user
    And I "activate" the user
    And there is 1 project
    And there is 1 tag
    And there is 1 user assigned to the project
    When I visit the project page
    Then I should see the project in the list
    When I click the assign link in the project list
    Then I should see the user in the list
    When I click checkbox to unassign project
    Then the project should be unassigned
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Delete a project

  An uploader should be able to delete a project

    Given I am an uploader
    And I am signed in
    And there is 1 project
    And there is 1 project image
    When I visit the project page
    Then I should see the project in the list
    When I click the delete link in the project list
    Then the project should be deleted
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @wip
  Scenario: Download project files

  An uploader should be able to download files for a project

    Given I am an uploader
    And I am signed in
    And there is 1 project
    And there is 1 project image
    When I visit the project page
    Then I should see the project in the list
    When I click the download link in the project list
    Then I should see a zip file
