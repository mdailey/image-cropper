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
    And there is 1 tag
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
