@ignore
Feature: Create a booking for test setup

  Scenario: Create booking
    Given url baseUrl
    And path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request bookingPayload
    When method post
    Then status 200
    And match response.bookingid == '#number'
    * def bookingId = response.bookingid
    * def booking = response.booking
