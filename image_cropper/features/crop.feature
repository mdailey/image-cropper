Feature: Crop

  In order to crop images of project, I need cropped page

  @javascript
  Scenario: Show assigned projects

  An cropper should be able to see assigned project

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And there is 1 project image
    And there is 1 user assigned to project
    When I visit the assigned project page
    Then I should see the assigned project in the list
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

@javascript
Scenario: Show images of assigned projects

An cropper should be able to see images of assigned project

  Given I am a cropper
  And I am signed in
  And there is 1 project
  And there is 1 project image
  And there is 1 user assigned to project
  When I visit the assigned project page
  Then I should see the assigned project in the list
  When I click the show link in the assigned project list
  Then I should see an image of assigned project
  And I should see a "current user" link
  When I click the "current user" link
  Then I should see a "Sign Out" link
  When I click the "Sign Out" link
  Then I should see a login form

@javascript
Scenario: Crop an image of assigned projects

An cropper should be able to crop an image of assigned project

  Given I am a cropper
  And I am signed in
  And there is 1 project
  And there is 1 project image
  And there is 1 user assigned to project
  When I visit the assigned project page
  Then I should see the assigned project in the list
  When I click the assign link in the assigned project list
  Then I should see an image of assigned project
  When I click on an image for cropping
  Then I should see cropped points on an image
  And I should see a "current user" link
  When I click the "current user" link
  Then I should see a "Sign Out" link
  When I click the "Sign Out" link
  Then I should see a login form
