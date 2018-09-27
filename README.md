# Hopefully simple event sourcing example

Very WIP, just messing around with some concepts.

## Commands
- Create events, and optionally the aggregate record if needed
- Give an opportunity to perform validation before commiting events to history

## Events
- Stored in DB, read only
- Each aggregate should have it's own table of associated events (referential integrity)
- Applied in series to construct the aggregate
- Should basically always follow the same data structure:
  - id
  - aggregate_id
  - data (jsonb)
  - meta (jsonb)
- data column should be deserialized into an OpenStructLike object, which can be chained together with #apply to build aggregate.
- #apply should not mutate the given object, but instead return a new object each time

## Aggregate
- Read-only models that are a view into the current state
- Effectively a cache of the current HEAD of the event stream
