Feature: looks addresses

  Scenario: Usage
    When I run `looks addresses --help`
    Then it should pass with:
      """
      Usage: looks addresses [options]
      """

  Scenario: Missing credentials
    When I run `looks addresses`
    Then it should fail with:
      """
      Usage: looks addresses [options]
      """

  Scenario: No connectivity
    Given I configure the default account
    When I run `looks addresses`
    Then it should fail with:
      """
      looks: error: Unable to connect to Gravatar server
      """

  Scenario: Default operation
    Given a test server is running
    And I configure the default account
    When I run `looks addresses`
    Then it should pass with:
      """
      alice@example.com
      alice@example.net
      alice@example.org
      """

  Scenario: Verbose output
    Given a test server is running
    And I configure the default account
    When I run `looks addresses --verbose`
    Then it should pass with:
      """
      alice@example.com
        1405e840549b8515a2c9eb41cd7126e5
      alice@example.net
        1405e840549b8515a2c9eb41cd7126e5
      alice@example.org
      """
