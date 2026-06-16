Feature: Delete booking

  As an API consumer
  I want to delete an existing booking
  So that I can remove booking records that are no longer needed

  Background:
    * url baseUrl
    * def credentials = read('classpath:data/auth-credentials.json')
    * def bookingPayload = read('classpath:data/create-booking-payload.json')

  Scenario: Delete an existing booking with token authentication
    Given path 'auth'
    And request credentials
    When method post
    Then status 200
    And match response.token == '#string'
    And match response.token != ''
    And def authToken = response.token

    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request bookingPayload
    When method post
    Then status 200
    And match response.bookingid == '#number'
    And def bookingId = response.bookingid

    Given path 'booking', bookingId
    And header Cookie = 'token=' + authToken
    When method delete
    Then status 201

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 404
