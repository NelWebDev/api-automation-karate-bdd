Feature: Get booking by id

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * set bookingPayload.firstname = 'GetById'
    * set bookingPayload.lastname = java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 12)
    * def created = call read('classpath:features/helpers/create-booking.feature') { bookingPayload: '#(bookingPayload)' }
    * def bookingId = created.bookingId
    * def tokenResult = callonce read('classpath:features/helpers/create-token.feature')
    * def authToken = tokenResult.authToken

  Scenario: Get the booking created by the test
    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response == bookingPayload
    And match response.bookingdates == { checkin: '#regex \\d{4}-\\d{2}-\\d{2}', checkout: '#regex \\d{4}-\\d{2}-\\d{2}' }
    And assert response.bookingdates.checkin < response.bookingdates.checkout

    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }
