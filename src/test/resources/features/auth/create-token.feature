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
