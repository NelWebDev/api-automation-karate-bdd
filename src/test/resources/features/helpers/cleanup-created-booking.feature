@ignore
Feature: Clean up a booking unexpectedly created by a negative test

  Scenario: Authenticate and delete booking
    * def tokenResult = call read('classpath:features/helpers/create-token.feature')
    * call read('classpath:features/helpers/delete-booking.feature') { bookingId: '#(bookingId)', authToken: '#(tokenResult.authToken)' }
