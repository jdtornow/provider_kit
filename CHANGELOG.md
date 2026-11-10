# provider_kit changelog

## v0.3.2 – 2026-11-10

- ProviderAttribute serializes to its key in as_json, fixing infinite recursion when a record holding one is converted to JSON
- A ProviderAttribute without a record also serializes to its key string, instead of a hash of its internal state

## v0.3.1 – 2026-01-10

- Fix internal bug related to symbol conversion

## v0.3.0 – 2026-01-09

- Removing dependency on ActiveSupport::Configurable to support Rails 8.2+

## v0.2.1 – 2025-09-24

- minor bug fixes and improvements
- separate out attribute from validation so providers can be nil
- Added `NullProvider` to allow for placeholder provider where one isn't needed but field is required. This is a no-op provider

## v0.2.0 – 2025-09-23

- Initial beta release abstracted from various applications over the years. This is a stable release that just needs some testing.
