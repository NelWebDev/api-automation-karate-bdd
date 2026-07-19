Feature: Get booking ids

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * set bookingPayload.firstname = 'GetIds'
    * set bookingPayload.lastname = java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 12)
    * def created = call read('classpath:features/helpers/create-booking.feature') { bookingPayload: '#(bookingPayload)' }
    * def bookingId = created.bookingId
    * def tokenResult = callonce read('classpath:features/helpers/create-token.feature')
    * def authToken = tokenResult.authToken

  Scenario: Get all booking ids
    Given path 'booking'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0
    And match each response contains { bookingid: '#number' }
    And match response contains { bookingid: '#(bookingId)' }

    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }
