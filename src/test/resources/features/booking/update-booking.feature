Feature: Update booking

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * set bookingPayload.lastname = 'Update' + java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 8)
    * def updatedBookingPayload = read('classpath:data/update-booking-payload.json')
    * def tokenResult = callonce read('classpath:features/helpers/create-token.feature')
    * def authToken = tokenResult.authToken
    * def created = call read('classpath:features/helpers/create-booking.feature') { bookingPayload: '#(bookingPayload)' }
    * def bookingId = created.bookingId

  Scenario: Update an existing booking with a valid JSON payload
    Given path 'booking', bookingId
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token=' + authToken
    And request updatedBookingPayload
    When method put
    Then status 200
    And match response == updatedBookingPayload
    And match response.bookingdates == { checkin: '#regex \\d{4}-\\d{2}-\\d{2}', checkout: '#regex \\d{4}-\\d{2}-\\d{2}' }
    And assert response.bookingdates.checkin < response.bookingdates.checkout

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response == updatedBookingPayload

    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }
