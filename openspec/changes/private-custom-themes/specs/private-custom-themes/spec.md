## Purpose

Permitir que cada usuario importe y utilice temas visuales completos y privados con sus propios recursos, sin distribuir contenido de terceros desde MeteoDex.

## ADDED Requirements

### Requirement: Import local theme package
The system SHALL allow the user to import a complete theme package from local device storage in a documented ZIP format on Android and iOS.

#### Scenario: Valid package is imported
- **WHEN** the user selects a valid ZIP theme package
- **THEN** the package is validated, stored locally, and becomes available in the user's theme list without requiring an account

#### Scenario: Invalid package is selected
- **WHEN** the selected package is damaged, unsupported, oversized, or fails validation
- **THEN** the system reports the import failure and keeps the previously active theme unchanged

### Requirement: Keep themes private
The system SHALL keep imported theme packages and their resources on the user's device and SHALL NOT upload, publish, or expose them to other users.

#### Scenario: Imported theme is used
- **WHEN** the user activates an imported theme
- **THEN** its resources are read from local storage and no network upload is performed

### Requirement: Manage imported themes
The system SHALL allow the user to import any number of themes, activate one available theme, and delete imported themes.

#### Scenario: User changes active theme
- **WHEN** the user selects an imported or built-in theme
- **THEN** the complete visual experience updates and the selected city, weather data, language, and temperature unit remain unchanged

#### Scenario: User deletes an inactive theme
- **WHEN** the user deletes an imported theme that is not active
- **THEN** its local package and resources are removed from the available theme list

#### Scenario: User deletes the active theme
- **WHEN** the user deletes the currently active imported theme
- **THEN** the system activates the default built-in theme before removing the imported resources

### Requirement: Support theme resources
The system SHALL support static PNG, JPG, or WebP images, animated GIF images, and user-provided TTF or OTF fonts inside a theme package.

#### Scenario: Theme contains supported resources
- **WHEN** a valid theme references supported images or fonts within its package
- **THEN** the application loads those resources from the package and applies them according to the theme configuration

### Requirement: Apply complete visual theme
The system SHALL allow an active imported theme to define the visual presentation of navigation, backgrounds, typography, icons, animations, weather states, loading states, error states, and unavailable-data states.

#### Scenario: Active theme renders the application
- **WHEN** an imported theme is active
- **THEN** all supported application surfaces use that theme's visual configuration while weather domain data remains unchanged

### Requirement: Provide generic theme template
The system SHALL provide a generic theme template that documents the package structure and rule format without bundling third-party characters, logos, names, or protected assets.

#### Scenario: User starts from the template
- **WHEN** the user opens the generic theme template
- **THEN** it contains examples with neutral identifiers that can be replaced with the user's own labels and resources