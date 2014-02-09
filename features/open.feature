Feature: looks open

  Scenario: Usage
    When I run `looks open --help`
    Then it should pass with:
      """
      Usage: looks open [options] <address>
      """

  Scenario: Missing arguments
    When I run `looks open`
    Then it should fail with:
      """
      Usage: looks open [options] <address>
      """

  Scenario: Default operation
    When I run `looks open --url alice@example.com`
    Then it should pass with:
      """
      http://localhost:8080/avatar/c160f8cc69a4f0bf2b0362752353d060
      """

