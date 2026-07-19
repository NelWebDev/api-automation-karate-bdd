@ignore
Feature: Delete a booking created by a test

  Scenario: Delete booking
    Given url baseUrl
    And path 'booking', bookingId
    And header Cookie = 'token=' + authToken
    When method delete
    Then status 201
