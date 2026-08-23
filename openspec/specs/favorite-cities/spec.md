# favorite-cities Specification

## Purpose
Allow users to search for locations, retain relevant cities, and access them quickly.

## Requirements

### Requirement: Worldwide city search and selection
The system SHALL allow the user to search for and select a city or town by name using a replaceable geocoding source.

#### Scenario: City is selected
- **WHEN** the user selects a search result
- **THEN** the application displays weather for that city and identifies the selected location

#### Scenario: Search returns no results
- **WHEN** no city matches the search
- **THEN** the application explains that no results were found and allows a new search

#### Scenario: Search source fails
- **WHEN** the geocoding source cannot be reached
- **THEN** the application presents a recoverable localized error

### Requirement: Favorite cities
The system SHALL allow the user to save, remove, and quickly select favorite cities.

#### Scenario: City is saved
- **WHEN** the user marks a selected city as favorite
- **THEN** it appears in the favorites list and remains available after restarting the application

#### Scenario: Favorite is removed
- **WHEN** the user removes a city from favorites
- **THEN** it no longer appears in the favorites list but remains searchable
