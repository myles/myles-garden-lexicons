# `garden.myles.*` — myles' garden lexicons

[AT Protocol Lexicon](https://atproto.com/specs/lexicon) schemas for records published by [myles' garden](https://myles.garden) projects.

Everything on `main` is published and resolvable. Browse them on [Lexicon Garden](https://lexicon.garden/browse?prefix=garden.myles).

## Lexicons

Lexicon JSON documents live under `garden/myles/<namespace>/`.

| Namespace                                     | Covers                    | Used by                             |
| --------------------------------------------- | ------------------------- | ----------------------------------- |
| [`garden.myles.aster`](./garden/myles/aster/) | Natal chart (birth chart) | [Aster](https://aster.myles.garden) |
| [`garden.myles.lending`](./garden/myles/lending/) | Tracking borrwed items | [lending](https://lending.myles.garden)

Example records live under [`examples/`](./examples/), one folder per namespace. CI validates them against the lexicons on each branch.

## Checks

CI runs the same npm scripts you can run locally. You need Node, `jq`, and Go; the first goat command builds a pinned goat into `.bin/`.

| Script              | Runs                                                                  |
| ------------------- | --------------------------------------------------------------------- |
| `npm run check`     | Formatting, JSON syntax, ids, script tests, lint, examples            |
| `npm run check:all` | `check`, plus breaking-change and DNS checks against what's published |

## See also

- [Lexicon spec](https://atproto.com/specs/lexicon): the AT Protocol schema language
- [lexicon.community](https://lexicon.community): community-maintained shared lexicons

## License

[MIT](./LICENSE)
