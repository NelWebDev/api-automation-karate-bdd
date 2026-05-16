Feature: Get booking ids by filters

  As an API consumer
  I want to filter booking ids by search data
  So that I can find bookings that match specific criteria

  Background:
    * url baseUrl

    Given path 'booking'
    When method get
    Then status 200
    And match response == '#[]'
    And def bookingId = response[0].bookingid

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And def booking = response

  Scenario: Filter booking ids by firstname
    Given path 'booking'
    And param firstname = booking.firstname
    When method get
    Then status 200
    And match response == '#[]'
    And match response contains { bookingid: #(bookingId) }

  Scenario: Filter booking ids by lastname
    Given path 'booking'
    And param lastname = booking.lastname
    When method get
    Then status 200
    And match response == '#[]'
    And match response contains { bookingid: #(bookingId) }

  Scenario: Filter booking ids by firstname and lastname
    Given path 'booking'
    And param firstname = booking.firstname
    And param lastname = booking.lastname
    When method get
    Then status 200
    And match response == '#[]'
    And match response contains { bookingid: #(bookingId) }

  Scenario: Filter booking ids by checkin date
    * def checkinDate = booking.bookingdates.checkin

    Given path 'booking'
    And param checkin = checkinDate
    When method get
    Then status 200
    And match response == '#[]'
    And match response[0].bookingid == '#number'
    And def filteredBookingId = response[0].bookingid

    Given path 'booking', filteredBookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And assert response.bookingdates.checkin >= checkinDate

  Scenario: Filter booking ids by checkout date
    * def checkoutDate = booking.bookingdates.checkout

    Given path 'booking'
    And param checkout = checkoutDate
    When method get
    Then status 200
    And match response == '#[]'
    And match response[0].bookingid == '#number'
    And def filteredBookingId = response[0].bookingid

    Given path 'booking', filteredBookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And assert response.bookingdates.checkout >= checkoutDate

  Scenario: Filter booking ids by checkin and checkout dates
    * def checkinDate = '1900-01-01'
    * def checkoutDate = '9999-12-31'

    Given path 'booking'
    And param checkin = checkinDate
    And param checkout = checkoutDate
    When method get
    Then status 200
    And match response == '#[]'
    And match each response contains { bookingid: '#number' }
    And match response[0].bookingid == '#number'
    And def filteredBookingId = response[0].bookingid

    Given path 'booking', filteredBookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And assert response.bookingdates.checkin >= checkinDate
    And assert response.bookingdates.checkout <= checkoutDate
