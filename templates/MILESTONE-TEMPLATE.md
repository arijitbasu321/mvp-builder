# Milestone N: [Title]

## Specifications

<!-- What to build in this milestone. Reference the user stories this milestone covers. -->

### User Stories Covered

- <!-- US-1: As a [user], I want [feature] so that [benefit] -->
- <!-- US-2: ... -->

### What to Build

<!-- Describe the concrete deliverables. Be specific about components, endpoints, pages, etc. -->

### AI Layer Guidelines

<!-- Only include this section if the milestone involves AI features. -->
<!-- Prompt management, eval criteria, accuracy targets, caching strategy, fallback behavior. -->
<!-- Remove this section entirely if the milestone has no AI components. -->

## Features

- [ ] <!-- Feature 1: Brief description -->
- [ ] <!-- Feature 2: Brief description -->
- [ ] <!-- Feature 3: Brief description -->

## Evaluation Conditions

Every condition must be independently testable. Each has a verification method.

| # | Condition | Verification Method |
|---|-----------|-------------------|
| 1 | <!-- "A user can register with email and password" --> | <!-- Playwright E2E test --> |
| 2 | <!-- "When an invalid email is submitted, the form shows an error" --> | <!-- Unit test --> |
| 3 | <!-- "The dashboard loads in under 2 seconds" --> | <!-- Playwright performance check --> |
| 4 | <!-- "An unauthorized user cannot access /api/protected" --> | <!-- Integration test --> |

> Every evaluation condition must have a corresponding test. "Manual" is acceptable only for visual/subjective checks (e.g., "the design looks professional") — but pair it with a Playwright screenshot test where possible.

## Wave Plan

<!-- LEFT EMPTY — Project Manager fills this during Phase II execution. -->
<!-- Waves are batches of related tasks that complete a feature. Max 5 tasks per wave. -->
