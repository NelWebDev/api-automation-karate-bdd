# API Automation Karate BDD

API test automation portfolio project built with Karate DSL, Maven, JUnit 5 and Java 17. It exercises the public [Restful Booker](https://restful-booker.herokuapp.com) API with isolated test data, reusable setup helpers, cleanup and CI reporting.

## Test coverage

- Authentication with valid and invalid credentials
- Retrieve all booking ids and retrieve a booking by id
- Filter by firstname, lastname, check-in and checkout dates
- Create, fully update and delete a booking
- Reject update and delete requests with missing or invalid authentication
- Response structure, data types and ISO date validation
- Negative contract tests for known upstream API defects

Tests that create valid bookings use unique data and delete those records when the scenario completes. Filter scenarios retry for a bounded period because the public API indexes newly created bookings asynchronously.

## Technology

- Karate 1.5.1
- JUnit 5
- Java 17
- Maven Wrapper 3.9.9
- GitHub Actions

The Maven Enforcer plugin fails early when Maven is not running on JDK 17, and the compiler uses `release=17` for a reproducible bytecode target.

## Project structure

```text
.
|-- .github/workflows/karate-tests.yml
|-- .mvn/wrapper/maven-wrapper.properties
|-- src/test/java/runners/KarateTestRunner.java
|-- src/test/resources/
|   |-- karate-config.js
|   |-- data/
|   `-- features/
|       |-- auth/
|       |-- booking/
|       `-- helpers/
|           |-- cleanup-created-booking.feature
|           |-- create-booking.feature
|           |-- create-token.feature
|           `-- delete-booking.feature
|-- mvnw
|-- mvnw.cmd
`-- pom.xml
```

Helper features are tagged `@ignore`: the runner does not execute them as standalone tests, but scenarios can reuse them with `call` or `callonce`.

## Requirements

- JDK 17 available through `JAVA_HOME`
- Internet access to Restful Booker and Maven Central

Verify the Java runtime used by Maven:

```bash
bash ./mvnw -version
```

On Windows PowerShell:

```powershell
.\mvnw.cmd -version
```

If Maven reports another Java version, correct `JAVA_HOME`. For example:

```powershell
$env:JAVA_HOME='C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot'
$env:Path="$env:JAVA_HOME\bin;$env:Path"
```

## Running tests

Stable regression suite:

```bash
bash ./mvnw clean test -Dkarate.options="--tags ~@knownBug"
```

PowerShell equivalent:

```powershell
.\mvnw.cmd clean test '-Dkarate.options=--tags ~@knownBug'
```

Known upstream defects only:

```bash
bash ./mvnw test -Dkarate.options="--tags @knownBug"
```

The default environment is `dev`. It can be selected explicitly:

```bash
bash ./mvnw test -Dkarate.env=dev
```

Override the configured API URL without editing the repository:

```bash
bash ./mvnw test -DbaseUrl=https://example.test
```

Unknown `karate.env` values fail fast unless `baseUrl` is supplied.

## Reports

Karate generates its HTML summary at:

```text
target/karate-reports/karate-summary.html
```

The CI workflow executes the stable suite and known-bug suite separately. Both Karate and Surefire reports are uploaded under `target/ci-reports/`. Known-bug failures do not hide stable regressions.

## Known upstream API bugs

Restful Booker is an intentionally imperfect API playground. The negative creation scenarios expect `400 Bad Request` for syntactically valid JSON with invalid field types. The current service violates that contract:

| Bug id | Field | Expected | Observed behavior |
| --- | --- | --- | --- |
| `@BUG-001` | `firstname` | `400` | `500` |
| `@BUG-002` | `lastname` | `400` | `500` |
| `@BUG-003` | `totalprice` | `400` | `200`, booking created |
| `@BUG-004` | `depositpaid` | `400` | `200`, booking created |
| `@BUG-005` | `bookingdates` | `400` | `500` |
| `@BUG-006` | `bookingdates.checkin` | `400` | `200`, booking created |
| `@BUG-007` | `bookingdates.checkout` | `400` | `200`, booking created |
| `@BUG-008` | `additionalneeds` | `400` | `200`, booking created |

These tests intentionally retain the correct expected contract and remain tagged `@knownBug`. If the API unexpectedly creates a booking, a helper deletes it before the contract assertion fails. CI runs these tests with `continue-on-error` and publishes their reports as evidence.

## Roadmap

- Partial update (`PATCH`) coverage
- Missing, `null` and malformed request bodies
- Response-time thresholds
- External JSON Schema validation
