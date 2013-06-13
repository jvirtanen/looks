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
