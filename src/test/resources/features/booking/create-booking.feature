Feature: Create booking

  As an API consumer
  I want to create a booking
  So that I can manage booking records through the API

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * set bookingPayload.lastname = 'Create' + java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 8)

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

    * def bookingId = response.bookingid
    * def tokenResult = call read('classpath:features/helpers/create-token.feature')
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(tokenResult.authToken)' }

  @negative @knownBug @BUG-001
  Scenario: Reject booking creation when firstname has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.firstname = 123
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400

  @negative @knownBug @BUG-002
  Scenario: Reject booking creation when lastname has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.lastname = 123
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400

  @negative @knownBug @BUG-003
  Scenario: Reject booking creation when totalprice has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.totalprice = 'abc'
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400

  @negative @knownBug @BUG-004
  Scenario: Reject booking creation when depositpaid has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.depositpaid = 'abc'
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400

  @negative @knownBug @BUG-005
  Scenario: Reject booking creation when bookingdates has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.bookingdates = '2018-01-01 to 2019-01-01'
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400

  @negative @knownBug @BUG-006
  Scenario: Reject booking creation when checkin has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.bookingdates.checkin = 20180101
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400

  @negative @knownBug @BUG-007
  Scenario: Reject booking creation when checkout has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.bookingdates.checkout = 20190101
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400

  @negative @knownBug @BUG-008
  Scenario: Reject booking creation when additionalneeds has an invalid data type
    * copy invalidBookingPayload = bookingPayload
    * set invalidBookingPayload.additionalneeds = 123
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request invalidBookingPayload
    When method post
    * if (responseStatus == 200) karate.call('classpath:features/helpers/cleanup-created-booking.feature', { bookingId: response.bookingid })
    Then status 400
