## Purpose

Permitir que un tema privado seleccione recursos visuales según la condición meteorológica y la temperatura, incluyendo una respuesta segura cuando no haya coincidencia.

## ADDED Requirements

### Requirement: Resolve weather-specific theme rule
The system SHALL resolve a theme rule using the current weather condition and Celsius temperature, considering optional minimum and maximum temperature bounds.

#### Scenario: Temperature matches a condition rule
- **WHEN** the current condition and temperature fall within a matching rule
- **THEN** the application displays the rule's configured label, resources, and presentation

#### Scenario: Rule has an open upper bound
- **WHEN** the current condition matches a rule with no maximum temperature and meets its minimum temperature
- **THEN** the application uses that rule for all higher temperatures

### Requirement: Resolve common weather conditions
The system SHALL support rules for sunny, cloudy, rain, snow, thunderstorm, and unknown weather conditions.

#### Scenario: Rain rule matches
- **WHEN** the current condition is rain and the temperature matches a rain rule
- **THEN** the application uses the rain rule rather than a sunny or generic rule

### Requirement: Handle missing rule matches
The system SHALL show the normal MeteoDex weather presentation without a custom resource when no theme rule matches the current condition and temperature.

#### Scenario: No custom rule matches
- **WHEN** no configured rule matches the current weather
- **THEN** the application presents the normal weather interface and remains usable

### Requirement: Reject ambiguous rule definitions
The system SHALL reject a theme package whose rules contain invalid ranges, unsupported conditions, missing referenced resources, or ambiguous overlaps that cannot be resolved deterministically.

#### Scenario: Theme contains overlapping rules
- **WHEN** two rules with the same condition match the same temperature and have no explicit priority
- **THEN** the package is rejected before activation and the current theme remains active