# API Automation Karate BDD

A small, professional base project for API test automation using Karate DSL, Maven, JUnit 5, and Gherkin-style feature files.

This repository is intentionally focused on a clean foundation for a QA Automation portfolio project. The current version covers authentication token generation, booking retrieval, booking creation, booking update, booking deletion, and negative contract checks for the Restful Booker API.

## Why This Project Exists

The goal of this project is to demonstrate readable API automation practices with clear BDD/Gherkin scenarios, simple test data management, CI execution, and report generation without over-engineering the first version.

Target API:

```text
https://restful-booker.herokuapp.com
```

## Tech Stack

- Karate DSL
- Maven
- JUnit 5
- Java 17
- Gherkin-style feature files
- GitHub Actions

## Current Test Coverage

- Generate authentication token with valid credentials
- Reject token generation with invalid login payloads
- Retrieve all existing booking ids
- Retrieve booking ids filtered by single and combined query parameters: firstname, lastname, checkin, and checkout
- Retrieve one booking by an existing id
- Create booking with a valid JSON payload
- Update an existing booking with a valid JSON payload and token authentication
- Delete an existing booking with token authentication
- Validate negative create booking scenarios with invalid field data types
- Validate HTTP status code
- Validate response body structure and key fields

## Project Structure

```text
api-automation-karate-bdd/
|-- .github/
|   `-- workflows/
|       `-- karate-tests.yml
|-- src/
|   `-- test/
|       |-- java/
|       |   `-- runners/
|       |       `-- KarateTestRunner.java
|       `-- resources/
|           |-- karate-config.js
|           |-- features/
|           |   |-- auth/
|           |   |   `-- create-token.feature
|           |   `-- booking/
|           |       |-- create-booking.feature
|           |       |-- delete-booking.feature
|           |       |-- get-booking-by-id.feature
|           |       |-- get-booking-ids-by-filter.feature
|           |       |-- get-booking-ids.feature
|           |       `-- update-booking.feature
|           `-- data/
|               |-- auth-credentials.json
|               |-- create-booking-payload.json
|               `-- update-booking-payload.json
|-- pom.xml
|-- README.md
`-- .gitignore
```

## Known API Bugs

Restful Booker is a public API playground for API testing practice. Its own landing page states that it is intentionally loaded with bugs to explore.

The `create-booking.feature` file includes negative contract tests for invalid JSON field data types. These scenarios expect `400 Bad Request`, because the request body is syntactically valid JSON but violates the API contract for field types.

The current API behavior does not return `400` for these cases. The scenarios are tagged as `@negative @knownBug` plus a traceable bug id:

| Bug id | Field | Expected | Actual behavior |
| --- | --- | --- | --- |
| `@BUG-001` | `firstname` | `400 Bad Request` | Returns `500 Internal Server Error` |
| `@BUG-002` | `lastname` | `400 Bad Request` | Returns `500 Internal Server Error` |
| `@BUG-003` | `totalprice` | `400 Bad Request` | Returns `200 OK` and creates the booking |
| `@BUG-004` | `depositpaid` | `400 Bad Request` | Returns `200 OK` and creates the booking |
| `@BUG-005` | `bookingdates` | `400 Bad Request` | Returns `500 Internal Server Error` |
| `@BUG-006` | `bookingdates.checkin` | `400 Bad Request` | Returns `200 OK` and creates the booking |
| `@BUG-007` | `bookingdates.checkout` | `400 Bad Request` | Returns `200 OK` and creates the booking |
| `@BUG-008` | `additionalneeds` | `400 Bad Request` | Returns `200 OK` and creates the booking |

These tests are intentionally kept failing when all tests are executed. A failing `@knownBug` test documents a real API defect instead of changing the assertion to match incorrect behavior.

## Run Tests Locally

This project requires Java 17 because Karate 1.5.1 is compiled for Java 17.

From the project root, verify Maven is using Java 17:

```bash
mvn -version
```

Then run:

```bash
mvn test
```

To run the suite without known API bugs:

```bash
mvn test -Dkarate.options="--tags ~@knownBug"
```

To run only the known API bugs:

```bash
mvn test -Dkarate.options="--tags @knownBug"
```

On Windows PowerShell, if Maven is still using another Java version, set `JAVA_HOME` for the current terminal session before running tests:

```powershell
$env:JAVA_HOME='C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot'
$env:Path="$env:JAVA_HOME\bin;$env:Path"
mvn clean test
```

## Run Tests With Environment

The default environment is `dev`. You can also pass it explicitly:

```bash
mvn test -Dkarate.env=dev
```

## Reports

Karate reports are generated after test execution in:

```text
target/karate-reports/
```

Open `target/karate-reports/karate-summary.html` in a browser to view the summary report after a local run.

On Windows PowerShell:

```powershell
Start-Process ".\target\karate-reports\karate-summary.html"
```

## CI/CD

GitHub Actions is configured in `.github/workflows/karate-tests.yml`.

The workflow runs on pushes and pull requests to `main`, sets up Java 17 with Temurin, caches Maven dependencies, runs Karate, and uploads the generated reports as a workflow artifact.

CI uses two separate executions:

- Stable regression suite: runs all tests except `@knownBug` scenarios. This keeps CI meaningful for new regressions.
- Known API bug checks: runs only `@knownBug` scenarios with `continue-on-error`. These checks are expected to fail until the API is fixed, but they still generate Karate evidence and a GitHub Actions summary for the development team.

The uploaded `karate-reports` artifact contains separate folders:

```text
target/ci-reports/
|-- stable/
|   |-- karate-reports/
|   `-- surefire-reports/
`-- known-bugs/
    |-- karate-reports/
    `-- surefire-reports/
```

Open `known-bugs/karate-reports/karate-summary.html` to review the detected API defects.

## Roadmap

- Schema validation
- Additional data-driven scenarios
