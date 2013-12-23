Feature: looks rm

  Scenario: Usage
    When I run `looks rm --help`
    Then it should pass with:
      """
      Usage: looks rm [options] <image>
      """

  Scenario: Missing argument
    When I run `looks rm`
    Then it should fail with:
      """
      Usage: looks rm [options] <image>
      """

  Scenario: Missing credentials
    When I run `looks rm foo`
    Then it should fail with:
      """
      Usage: looks rm [options] <image>
      """

  Scenario: No connectivity
    Given I configure the default account
    When I run `looks rm foo`
    Then it should fail with:
      """
      looks: error: Unable to connect to Gravatar server
      """

  Scenario: Unknown identifier
    Given a test server is running
    And I configure the default account
    When I run `looks rm xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
    Then it should fail with:
      """
      looks: error: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: Unknown identifier
      """

  Scenario: Default operation
    Given a test server is running
    And I configure the default account
    When I run `looks rm 1405e840549b8515a2c9eb41cd7126e5`
    And I run `looks addresses --verbose`
    Then it should pass with:
      """
      alice@example.com
      alice@example.net
      alice@example.org
      """
