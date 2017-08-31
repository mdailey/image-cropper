Feature: Project

  In order to organize image cropping, I need projects

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
    And there is 1 cropper
    And I "activate" the user
    And there is 1 project
    When I visit the project page
    Then I should see the project in the list
    When I click the assign link in the project list
    Then I should see the user in the list
    When I click the checkbox to assign the user to the project
    And I visit the project page
    Then I should see the project in the list
    When I click the assign link in the project list
    Then I should see the user assigned in the list
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  Scenario: Unassign user from project

  An admin/uploader should be able to unassign a user from a project

    Given I am an admin
    And I am signed in
    And there is 1 cropper
    And I "activate" the user
    And there is 1 project
    And the project has 1 tag
    And there is 1 user assigned to the project
    When I visit the project page
    Then I should see the project in the list
    When I click the assign link in the project list
    Then I should see the user assigned in the list
    When I click the checkbox to unassign the user from the project
    And I visit the project page
    Then I should see the project in the list
    When I click the assign link in the project list
    Then I should see the user unassigned in the list
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
    Then the project should be deleted from the project list
    And I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

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
    When I visit the project page
    Then I should see a "current user" link
    When I click the "current user" link
    Then I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form

  @javascript
  @selenium
  Scenario: Get YML and CNN text files for project

    Given I am an uploader
    And there is 1 project
    And the project has 1 tag
    And there is 1 project image
    And there is 1 cropper
    And there is 1 user assigned to the project
    And there are 2 crops for the project image
    And the project image files are synced
    And I am signed in
    When I visit the project page
    Then I should see the project in the list
    And I should see the download link in the project list
    When I open the downloaded ZIP file
    Then I should see a CNN text file for the project image
    And I should see a YML file for the project

  @javascript
  @selenium
  Scenario: Download images with crops only

    Given I am an uploader
    And there is 1 project
    And the project has 1 tag
    And there are 2 project images
    And there are 2 crops for project image 1
    And the project image files are synced
    And I am signed in
    When I visit the project page
    Then I should see the project in the list
    And I should see the download link in the project list
    When I open the downloaded ZIP file
    Then I should see 1 project image in the ZIP file
    And I should see 2 crop images in the ZIP file

  Scenario: Change rectangle thickness

    Given I am an uploader
    And there is 1 project
    And the project has 1 tag
    And I am signed in
    When I visit the project page
    Then I should see the project in the list
    When I click the edit link in the project list
    Then I should see a project form
    When I change the rectangle thickness for the project
    Then I should see the project information
    And the rectangle thickness should be changed
    And I should see a "current user" link
    When I click the "current user" link
    And I should see a "Sign Out" link
    When I click the "Sign Out" link
    Then I should see a login form
