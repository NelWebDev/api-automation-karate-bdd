Feature: Booking authorization

  Background:
    * url baseUrl
    * def bookingPayload = read('classpath:data/create-booking-payload.json')
    * set bookingPayload.lastname = 'Auth' + java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 8)
    * def created = call read('classpath:features/helpers/create-booking.feature') { bookingPayload: '#(bookingPayload)' }
    * def bookingId = created.bookingId
    * def tokenResult = callonce read('classpath:features/helpers/create-token.feature')
    * def authToken = tokenResult.authToken

  Scenario Outline: Reject update without valid authentication
    Given path 'booking', bookingId
    And header Content-Type = 'application/json'
    And header Cookie = <cookie>
    And request bookingPayload
    When method put
    Then status 403
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }

    Examples:
      | cookie          |
      | ''              |
      | 'token=invalid' |

  Scenario Outline: Reject delete without valid authentication
    Given path 'booking', bookingId
    And header Cookie = <cookie>
    When method delete
    Then status 403
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(authToken)' }

    Examples:
      | cookie          |
      | ''              |
      | 'token=invalid' |
