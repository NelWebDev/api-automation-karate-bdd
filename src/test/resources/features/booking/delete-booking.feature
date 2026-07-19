Feature: Delete booking

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * set bookingPayload.lastname = 'Delete' + java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 8)
    * def tokenResult = callonce read('classpath:features/helpers/create-token.feature')
    * def authToken = tokenResult.authToken
    * def created = call read('classpath:features/helpers/create-booking.feature') { bookingPayload: '#(bookingPayload)' }
    * def bookingId = created.bookingId

  Scenario: Delete an existing booking with token authentication
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 404
