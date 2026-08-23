## Purpose

Ofrecer una experiencia coherente en los idiomas soportados y conservar las preferencias principales del usuario entre sesiones.

## ADDED Requirements

### Requirement: Supported languages
The system SHALL provide Japanese, Chinese, Italian, Portuguese, Castilian Spanish, neutral Spanish, and English for user-facing application text.

#### Scenario: User changes language
- **WHEN** the user selects a supported language in settings
- **THEN** visible application text updates to that language without restarting the application

#### Scenario: Unsupported language is requested
- **WHEN** a saved or requested language is not supported
- **THEN** the application uses Castilian Spanish as the fallback language

### Requirement: Persisted preferences
The system SHALL persist the selected language and launcher and restore them when the application starts again.

#### Scenario: Application restarts
- **WHEN** the user opens the application after previously selecting language and launcher
- **THEN** those selections are restored
