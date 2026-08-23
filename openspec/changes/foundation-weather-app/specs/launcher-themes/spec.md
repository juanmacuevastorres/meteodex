## Purpose

Permitir que la experiencia meteorologica adopte distintos launchers visuales seleccionables, sin acoplar la informacion del tiempo a una estetica concreta.

## ADDED Requirements

### Requirement: Selectable launcher
The system SHALL allow the user to select an available launcher and apply it to the weather experience.

#### Scenario: User selects a launcher
- **WHEN** the user selects an available launcher
- **THEN** the weather screen updates its visual presentation without losing the selected city or weather data

#### Scenario: Launcher is unavailable
- **WHEN** a previously selected launcher is no longer available
- **THEN** the application falls back to the default original launcher

### Requirement: Extensible visual contract
The system SHALL define launcher behavior through a common visual contract that supports weather states, loading, empty, and error presentations.

#### Scenario: New launcher is added
- **WHEN** a new launcher implements the supported visual contract
- **THEN** it can be offered without changing the weather data contract
