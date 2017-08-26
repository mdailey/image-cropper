
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
    Then I should see 1 object selected on the image
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Crop an image with an arbitrary polygon

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And the project has 1 tag
    And the project allows arbitrary polygons
    And there is 1 project image
    And the project image files are synced
    And I am assigned to the project
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    When I select an object on the image to be cropped with a polygon
    Then I should see 1 object selected on the image
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

  @javascript
  Scenario: Show crops from multiple users

  A cropper should be able to see crops made by another cropper

    Given there is 1 project
    And the project has 1 tag
    And there is 1 project image
    And there are 2 users assigned to the project
    And cropper 1 has selected 2 objects
    And the project image files are synced
    And I am cropper 2
    And I am signed in
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    And I should see 2 crops
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Crop image for project with multiple tags

  A cropper should be able to crop an image in an assigned project
  with more than one tag

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And the project has 2 tags
    And there is 1 project image
    And the project image files are synced
    And I am assigned to the project
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    When I select an object on the image to be cropped and give it a tag
    Then I should see 1 object selected on the image
    And the object should have the correct tag
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Crop by dragging

  A cropper should be able to crop an image in a project
  with 2 points by dragging the mouse

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And the project uses 2 points
    And the project has 1 tag
    And there is 1 project image
    And the project image files are synced
    And I am assigned to the project
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    When I select an object by dragging
    Then I should see 1 object selected on the image
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Thick rectangles

  A cropper should be able to see thicker rectangles
  if selected for the project

    Given I am a cropper
    And I am signed in
    And there is 1 project
    And I am assigned to the project
    And the project has rectangle thickness 3
    And the project has 1 tag
    And there is 1 project image
    And there is 1 crop for the project image
    And the project image files are synced
    When I visit the assigned projects page
    Then I should see the assigned project in the list
    When I click the crop images link in the assigned project list
    Then I should see an image from the assigned project
    And I should see 1 object selected on the image
    And the rectangle thickness should be 3
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form
