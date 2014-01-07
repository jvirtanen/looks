Feature: looks config

  Scenario: Usage
    When I run `looks config --help`
    Then it should pass with:
      """
      Usage: looks config
      """

  Scenario: Configuring the default account
    When I run `looks config` interactively
    And I type "alice"
    And I type "secret"
    Then a file named "HOME/.looks" should exist
    And the file named "HOME/.looks" should not be world readable

  Scenario: Configuration file not writable
    Given an empty file named "HOME/.looks"
    And I run `chmod u-w HOME/.looks`
    When I configure the default account
    Then it should fail with:
      """
      HOME/.looks: Cannot write file
      """
