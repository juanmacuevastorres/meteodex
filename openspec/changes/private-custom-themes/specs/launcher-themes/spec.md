## MODIFIED Requirements

### Requirement: Extensible visual contract
The system SHALL define launcher and theme behavior through a common visual contract that supports weather states, loading, empty, error, unavailable-data presentations, and complete application surfaces.

#### Scenario: New launcher is added
- **WHEN** a new launcher implements the supported visual contract
- **THEN** it can be offered without changing the weather data contract

#### Scenario: Imported theme is added
- **WHEN** a valid local theme implements the supported visual contract through its package configuration
- **THEN** it can be offered alongside built-in launchers without changing the weather data contract

#### Scenario: Theme omits a custom weather rule
- **WHEN** an active theme has no matching rule for the current weather
- **THEN** the common contract presents the normal MeteoDex weather experience without a custom resource

### Requirement: Animated launcher scenes
Each launcher or imported theme MAY provide an original animated scene that reflects its visual language while keeping weather data neutral. Any provided scene MUST keep weather data neutral and use only original or authorized resources.

#### Scenario: Retro weather scene is active
- **WHEN** the Retro launcher is selected
- **THEN** weather is presented with pixel art and animated falling block pieces

#### Scenario: Non-retro launcher is active
- **WHEN** Adventure, Battle, Ninja, or Digital is selected
- **THEN** the launcher presents its own animated non-pixel visual treatment without third-party characters, logos, or protected assets

#### Scenario: Imported animated resource is active
- **WHEN** an imported theme references a valid local GIF animation
- **THEN** the application displays the animation on supported themed surfaces without distributing the resource