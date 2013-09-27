Feature: looks push

  Scenario: Usage
    When I run `looks push --help`
    Then it should pass with:
      """
      Usage: looks push [options] <filename>
      """

  Scenario: Missing argument
    When I run `looks push`
    Then it should fail with:
      """
      Usage: looks push [options] <filename>
      """

  Scenario: Missing credentials
    When I run `looks push foo.png`
    Then it should fail with:
      """
      Usage: looks push [options] <filename>
      """

  Scenario: File not found
    Given I configure the default account
    When I run `looks push foo.png`
    Then it should fail with:
      """
      looks: error: foo.png: File not found
      """

  Scenario: Cannot read file
    Given an empty file named "foo.png"
    And I run `chmod u-r foo.png`
    And I configure the default account
    When I run `looks push foo.png`
    Then it should fail with:
      """
      looks: error: foo.png: Cannot read file
      """

  Scenario: Unknown file format
    Given a test server is running
    And an empty file named "foo.png"
    And I configure the default account
    When I run `looks push foo.png`
    Then it should fail with:
      """
      looks: error: Unknown error (-100)
      """

  Scenario: Default operation
    Given a test server is running
    And the file named "pink.png"
    And I configure the default account
    When I run `looks push pink.png`
    Then it should pass with:
      """
      60459ef8f2d70dbdf2642d71d27804b1
      """
