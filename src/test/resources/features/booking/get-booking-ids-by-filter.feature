Feature: Get booking ids by filters

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * set bookingPayload.firstname = 'Filter' + java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 8)
    * set bookingPayload.lastname = 'Test' + java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 8)
    * def created = call read('classpath:features/helpers/create-booking.feature') { bookingPayload: '#(bookingPayload)' }
    * def bookingId = created.bookingId
    * def booking = created.booking
    * def tokenResult = callonce read('classpath:features/helpers/create-token.feature')
    * def authToken = tokenResult.authToken
    * configure retry = { count: 10, interval: 1000 }

  Scenario Outline: Filter booking ids by name
    Given path 'booking'
    And params <filters>
    And retry until responseStatus == 200 && response.some(x => x.bookingid == bookingId)
    When method get
    Then status 200
    And match response == '#[]'
    And match response contains { bookingid: '#(bookingId)' }

    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }

    Examples:
      | filters                                                    |
      | { firstname: '#(booking.firstname)' }                      |
      | { lastname: '#(booking.lastname)' }                        |
      | { firstname: '#(booking.firstname)', lastname: '#(booking.lastname)' } |

  Scenario: Filter booking ids by checkin date
    * def checkinDate = '2017-12-31'
    Given path 'booking'
    And param checkin = checkinDate
    And retry until responseStatus == 200 && response.some(x => x.bookingid == bookingId)
    When method get
    Then status 200
    And match response contains { bookingid: '#(bookingId)' }
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }

  Scenario: Filter booking ids by checkout date
    * def checkoutDate = '2019-01-02'
    Given path 'booking'
    And param checkout = checkoutDate
    And retry until responseStatus == 200 && response.some(x => x.bookingid == bookingId)
    When method get
    Then status 200
    And match response contains { bookingid: '#(bookingId)' }
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }

  Scenario: Filter booking ids by checkin and checkout dates
    Given path 'booking'
    And param checkin = '2017-12-31'
    And param checkout = '2019-01-02'
    And retry until responseStatus == 200 && response.some(x => x.bookingid == bookingId)
    When method get
    Then status 200
    And match response contains { bookingid: '#(bookingId)' }
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }

  Scenario: Return an empty list when name filters do not match
    Given path 'booking'
    And param firstname = 'DoesNotExist' + java.util.UUID.randomUUID().toString()
    When method get
    Then status 200
    And match response == []
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }
