Feature: looks rm

  Scenario: Usage
    When I run `looks rm --help`
    Then it should pass with:
      """
      Usage: looks rm [options] <id>
      """

  Scenario: Missing argument
    When I run `looks rm`
    Then it should fail with:
      """
      Usage: looks rm [options] <id>
      """

  Scenario: Missing credentials
    When I run `looks rm foo`
    Then it should fail with:
      """
      Usage: looks rm [options] <id>
      """
