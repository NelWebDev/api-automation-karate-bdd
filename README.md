# API Automation Karate BDD

A small, professional base project for API test automation using Karate DSL, Maven, JUnit 5, and Gherkin-style feature files.

This repository is intentionally focused on the first clean foundation for a QA Automation portfolio project. The current version covers only the authentication token generation flow for the Restful Booker API and is ready to grow later with booking CRUD scenarios.

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
- Validate HTTP status code
- Validate response body contains a valid token

## Project Structure

```text
api-automation-karate-bdd/
├── .github/
│   └── workflows/
│       └── karate-tests.yml
├── src/
│   └── test/
│       ├── java/
│       │   └── runners/
│       │       └── KarateTestRunner.java
│       └── resources/
│           ├── karate-config.js
│           ├── features/
│           │   └── auth/
│           │       └── create-token.feature
│           └── data/
│               └── auth-credentials.json
├── pom.xml
├── README.md
└── .gitignore
```

## Run Tests Locally

From the project root, run:

```bash
mvn test
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

## CI/CD

GitHub Actions is configured in `.github/workflows/karate-tests.yml`.

The workflow runs on pushes and pull requests to `main`, sets up Java 17 with Temurin, caches Maven dependencies, runs the Karate test suite, and uploads the generated Karate reports as a workflow artifact.

## Roadmap

- Create booking
- Get booking
- Update booking
- Delete booking
- Negative authentication scenarios
- Schema validation
- Data-driven scenarios
