## Purpose

Define la base funcional para consultar y presentar informacion meteorologica por ciudad, con una fuente externa sustituible y estados claros para el usuario.

## ADDED Requirements

### Requirement: Weather data contract
The system SHALL represent current weather and forecast data independently from the provider that supplies it.

#### Scenario: Weather data is available
- **WHEN** a weather source returns valid current conditions for a city
- **THEN** the application presents the location, temperature, condition, update time, and forecast values

#### Scenario: Weather data is unavailable
- **WHEN** the weather source cannot return data
- **THEN** the application presents a recoverable error and preserves the last valid cached result when one exists

### Requirement: Current location weather
The system SHALL allow the user to request weather for the device's current city after granting location permission.

#### Scenario: Location permission is granted
- **WHEN** the user requests weather for the current location and grants permission
- **THEN** the application resolves the city and loads its weather

#### Scenario: Location permission is denied
- **WHEN** the user denies location permission
- **THEN** the application explains that permission is unavailable and offers manual city search
