# API Automation Karate BDD

A small, professional base project for API test automation using Karate DSL, Maven, JUnit 5, and Gherkin-style feature files.

This repository is intentionally focused on a clean foundation for a QA Automation portfolio project. The current version covers authentication token generation and booking retrieval scenarios for the Restful Booker API.

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
|           |       |-- get-booking-by-id.feature
|           |       |-- get-booking-ids-by-filter.feature
|           |       `-- get-booking-ids.feature
|           `-- data/
|               `-- auth-credentials.json
|-- pom.xml
|-- README.md
`-- .gitignore
```

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

The workflow runs on pushes and pull requests to `main`, sets up Java 17 with Temurin, caches Maven dependencies, runs the Karate test suite, and uploads the generated Karate reports as a workflow artifact.

## Roadmap

- Create booking
- Update booking
- Delete booking
- Schema validation
- Additional data-driven scenarios
