Feature: Update booking

  As an API consumer
  I want to update an existing booking
  So that I can keep booking records accurate

  Background:
    * url baseUrl
    * def credentials = read('classpath:data/auth-credentials.json')
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * def updatedBookingPayload = read('classpath:data/update-booking-payload.json')

  Scenario: Update an existing booking with a valid JSON payload
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
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token=' + authToken
    And request updatedBookingPayload
    When method put
    Then status 200
    And match response == updatedBookingPayload
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
        additionalneeds: '#string'
      }
      """

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response == updatedBookingPayload
