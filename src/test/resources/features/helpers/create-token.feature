@ignore
Feature: Create an authentication token for test setup

  Scenario: Create token
    Given url baseUrl
    And path 'auth'
    And request read('classpath:data/auth-credentials.json')
    When method post
    Then status 200
    And match response.token == '#string'
    And match response.token != ''
    * def authToken = response.token
