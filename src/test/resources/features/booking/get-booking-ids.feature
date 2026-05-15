Feature: Get booking ids

  As an API consumer
  I want to retrieve all existing booking ids
  So that I can use them in booking workflows

  Background:
    * url baseUrl

  Scenario: Get all booking ids
    Given path 'booking'
    When method get
    Then status 200
    And match response == '#[]'
    And match each response contains { bookingid: '#number' }
    And match response[0].bookingid == '#number'
