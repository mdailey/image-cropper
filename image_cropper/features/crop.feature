
Feature: Crop

  In order to allow croppers to do their work, I need
  a cropping page.

  @javascript
  Scenario: Show assigned projects

  A cropper should be able to see his or her assigned project

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And the project has 1 tag
    And there is 1 project image
    And I am assigned to the project
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Show images of assigned projects

  A cropper should be able to see images of assigned project

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And the project has 1 tag
    And there is 1 project image
    And the project image files are synced
    And I am assigned to the project
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Crop an image of assigned project

  A cropper should be able to crop an image in an assigned project

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And the project has 1 tag
    And there is 1 project image
    And the project image files are synced
    And I am assigned to the project
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    When I select an object on the image to be cropped
    Then I should see the object selected on the image
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Remove a selected object after cropping it

  A cropper should be able to delete a cropped image

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And the project has 1 tag
    And there is 1 project image
    And the project image files are synced
    And I am assigned to the project
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    When I crop 2 patches then delete 1 patch
    Then there should be 1 patch left
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

