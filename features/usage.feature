Feature: looks

  Scenario: Usage
    When I run `looks`
    Then it should fail with:
      """
      Usage: looks <command> [arguments]
      """
