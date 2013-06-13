Feature: looks set

  Scenario: Usage
    When I run `looks set --help`
    Then it should pass with:
      """
      Usage: looks set [options] <address> <id>
      """

  Scenario: Missing arguments
    When I run `looks set`
    Then it should fail with:
      """
      Usage: looks set [options] <address> <id>
      """

  Scenario: Missing credentials
    When I run `looks set alice@example.com foo`
    Then it should fail with:
      """
      Usage: looks set [options] <address> <id>
      """
