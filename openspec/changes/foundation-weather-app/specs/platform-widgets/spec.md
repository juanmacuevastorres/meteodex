## Purpose

Preparar una experiencia resumida del tiempo para widgets del sistema, respetando las capacidades especificas de Android e iOS.

## ADDED Requirements

### Requirement: Widget weather summary
The system SHALL provide a platform widget representation with the selected city, current temperature, condition, and last update status.

#### Scenario: Widget has fresh data
- **WHEN** the widget receives current weather data
- **THEN** it displays the selected city, temperature, condition, and update time

#### Scenario: Widget data is stale or unavailable
- **WHEN** the widget cannot refresh weather data
- **THEN** it displays the last known values or a clear unavailable state

### Requirement: Widget respects preferences
The system SHALL allow the widget to use the user's selected language and launcher-compatible visual style where the platform permits it.

#### Scenario: User changes language
- **WHEN** the user changes the application language
- **THEN** the next widget refresh uses the selected language
