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
