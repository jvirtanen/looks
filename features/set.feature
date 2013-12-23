Feature: looks set

  Scenario: Usage
    When I run `looks set --help`
    Then it should pass with:
      """
      Usage: looks set [options] <address> <image>
      """

  Scenario: Missing arguments
    When I run `looks set`
    Then it should fail with:
      """
      Usage: looks set [options] <address> <image>
      """

  Scenario: Missing credentials
    When I run `looks set alice@example.com foo`
    Then it should fail with:
      """
      Usage: looks set [options] <address> <image>
      """

  Scenario: No connectivity
    Given I configure the default account
    When I run `looks set alice@example.com foo`
    Then it should fail with:
      """
      looks: error: Unable to connect to Gravatar server
      """

  Scenario: Unknown address
    Given a test server is running
    And I configure the default account
    When I run `looks set bob@example.org 1405e840549b8515a2c9eb41cd7126e5`
    Then it should fail with:
      """
      looks: error: bob@example.org: Unknown email address
      """

  Scenario: Unknown identifier
    Given a test server is running
    And I configure the default account
    When I run `looks set alice@example.org xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
    Then it should fail with:
      """
      looks: error: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: Unknown identifier
      """

  Scenario: Default operation
    Given a test server is running
    And I configure the default account
    When I run `looks set alice@example.org 1405e840549b8515a2c9eb41cd7126e5`
    And I run `looks addresses --verbose`
    Then it should pass with:
      """
      alice@example.org
        1405e840549b8515a2c9eb41cd7126e5
      """
