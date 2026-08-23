# localization-preferences Specification

## Purpose
Provide supported languages and persist the user's main presentation preferences between sessions.

## Requirements

### Requirement: Supported languages
The system SHALL provide Japanese, Chinese, Italian, Portuguese, Castilian Spanish, neutral Spanish, and English for user-facing application text.

#### Scenario: User changes language
- **WHEN** the user selects a supported language in settings
- **THEN** visible application text updates to that language without restarting the application

#### Scenario: Unsupported language is requested
- **WHEN** a saved or requested language is not supported
- **THEN** the application uses Castilian Spanish as the fallback language

### Requirement: Persisted preferences
The system SHALL persist the selected language, launcher, current city, and favorite city identifiers through a local storage interface and restore them when the application starts again.

#### Scenario: Application restarts
- **WHEN** the user opens the application after previously selecting language, launcher, city, or favorites
- **THEN** those selections are restored
