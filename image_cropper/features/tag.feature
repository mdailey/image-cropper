Feature: Tag

  In order to crop images of project, I need to define what user should crop

  @javascript
  Scenario: Add a tag

  An uploader should be able to add a tag

    Given I am an uploader
    And I am signed in
    When I visit the tag page
    Then I should see a "New Tag" link
    When I click the "New Tag" link
    Then I should see a tag form
    When I submit the tag information
    Then I should see the tag in the list
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Edit a tag

  An uploader should be able to edit a tag

    Given I am an uploader
    And I am signed in
    And there is 1 unassigned tag
    When I visit the tag page
    Then I should see the tag in the list
    When I click the edit link in the tag list
    Then I should see a tag form
    When I submit the tag information
    Then I should see the tag in the list
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Add a tag to a project

  An uploader should be able to associate tags with a project

    Given I am an uploader
    And I am signed in
    And there is 1 project
    And there is 1 unassigned tag
    When I visit the project page
    Then I should see the project in the list
    When I click the edit link in the project list
    Then I should see a tag list for the project
    And the tag list for the project should be empty
    When I add the tag to the project
    Then I should see the tag in the tag list for the project
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Delete a tag from a project

  An uploader should be able to remove tags associated with a project

    Given I am an uploader
    And I am signed in
    And there is 1 project
    And the project has 1 tag
    When I visit the project page
    Then I should see the project in the list
    When I click the edit link in the project list
    Then I should see a tag list for the project
    And the tag list for the project should not be empty
    And I should see the tag in the tag tokeninput list for the project
    When I delete the tag from the project
    Then the tag list for the project should be empty
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form
