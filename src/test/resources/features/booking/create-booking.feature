Feature: Create booking

  As an API consumer
  I want to create a booking
  So that I can manage booking records through the API

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')

  Scenario: Create a booking with valid JSON payload
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request bookingPayload
    When method post
    Then status 200
    And match response.bookingid == '#number'
    And match response.booking == bookingPayload
    And match response ==
      """
      {
        bookingid: '#number',
        booking: {
          firstname: '#string',
          lastname: '#string',
          totalprice: '#number',
          depositpaid: '#boolean',
          bookingdates: {
            checkin: '#string',
            checkout: '#string'
          },
          additionalneeds: '#string'
        }
      }
      """
