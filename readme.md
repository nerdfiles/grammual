# Grammuelle

A Grammacology of Design: Grammuelle is a SASS minimalistic framework for  
building cellular designs (all puns intented).

## Example

Module-level interplay goes here, or meta-CSS type junk like:

1. `modules`
2. `grids`
3. `displays`
4. `hooks` (`before`, `after` order serializations)
5. `models`

Generally the design ontology should be implemented within an __internal__:

1. `Ifs`
2. `Onces`
3. `Spreads`
4. `Classes`
5. `Withs`
6. `Responses`
7. `Rules

## Install

    $ bower install grammuelle

`theme.scss` and `__interface__.scss` are good places to start. The latter is
like a `master style` booklet for your project. After you are done preparing
your grids, modules, rules, hooks, responses, etc., `import` your interface:

    @import "__interface__";

## Documentation

See `./docs/` or [Web docs](http://grammuelle.io/docs).

## Glossary

See `./glossary.md`

## Idioms

See `./idioms.md`

## Contribute

See `./CONTRIBUTE`

## License

See `./LICENSE`
