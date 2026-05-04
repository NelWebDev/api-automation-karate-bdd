Feature: Auth token generation

  As an API consumer
  I want to generate an authentication token
  So that I can access protected booking endpoints

  Background:
    * url baseUrl
    * def credentials = read('classpath:data/auth-credentials.json')

  Scenario: Generate token with valid credentials
    Given path 'auth'
    And request credentials
    When method post
    Then status 200
    And match response.token == '#string'
    And match response.token != ''

  Scenario Outline: Reject token generation with invalid login payloads
    * def loginPayload = <payload>
    Given path 'auth'
    And request loginPayload
    When method post
    Then status 200
    And match response == { reason: 'Bad credentials' }
    And match response.token == '#notpresent'

    Examples:
      | payload                                             |
      | { username: 'admin', password: 'wrong-password' }    |
      | { username: 'invalid', password: 'password123' }     |
      | { username: 'invalid', password: 'wrong-password' }  |
      | { username: '', password: 'password123' }            |
      | { username: 'admin', password: '' }                  |
      | { username: '', password: '' }                       |
      | { password: 'password123' }                          |
      | { username: 'admin' }                                |
      | {}                                                  |
