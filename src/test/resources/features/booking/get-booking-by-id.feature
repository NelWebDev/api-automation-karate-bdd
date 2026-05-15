Feature: Get booking by id

  As an API consumer
  I want to retrieve a booking by id
  So that I can validate the booking detail data

  Background:
    * url baseUrl

  Scenario: Get one booking by existing id
    Given path 'booking'
    When method get
    Then status 200
    And match response == '#[]'
    And def bookingId = response[0].bookingid

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response ==
      """
      {
        firstname: '#string',
        lastname: '#string',
        totalprice: '#number',
        depositpaid: '#boolean',
        bookingdates: {
          checkin: '#string',
          checkout: '#string'
        },
        additionalneeds: '#ignore'
      }
      """
