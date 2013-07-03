Feature: looks images

  Scenario: Usage
    When I run `looks images --help`
    Then it should pass with:
      """
      Usage: looks images [options]
      """

  Scenario: Missing credentials
    When I run `looks images`
    Then it should fail with:
      """
      Usage: looks images [options]
      """

  Scenario: Default operation
    Given a test server is running
    And I configure the default account
    When I run `looks images`
    Then it should pass with:
      """
      1405e840549b8515a2c9eb41cd7126e5
      """

  Scenario: Verbose output
    Given a test server is running
    And I configure the default account
    When I run `looks images --verbose`
    Then it should pass with:
      """
      1405e840549b8515a2c9eb41cd7126e5
        alice@example.com
        alice@example.net
      """
