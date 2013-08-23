Feature: looks unset

  Scenario: Usage
    When I run `looks unset --help`
    Then it should pass with:
      """
      Usage: looks unset [options] <address>
      """

  Scenario: Missing arguments
    When I run `looks unset`
    Then it should fail with:
      """
      Usage: looks unset [options] <address>
      """

  Scenario: Missing credentials
    When I run `looks unset alice@example.com`
    Then it should fail with:
      """
      Usage: looks unset [options] <address>
      """

  Scenario: Unknown address
    Given a test server is running
    And I configure the default account
    When I run `looks unset bob@example.com`
    Then it should fail with:
      """
      looks: error: bob@example.com: Unknown email address
      """

  Scenario: Default operation
    Given a test server is running
    And I configure the default account
    When I run `looks unset alice@example.com`
    And I run `looks addresses --verbose`
    Then it should pass with:
      """
      alice@example.com
      alice@example.net
        1405e840549b8515a2c9eb41cd7126e5
      alice@example.org
      """
