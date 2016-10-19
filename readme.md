# Grammuelle

<div style="min-width: 100%; text-align: center;">
<img width="320px" src="https://raw.githubusercontent.com/nerdfiles/grammuelle/master/images/logo.png" alt="Logo" />
<div class="cite">
<i>A Grammacology of Design</i>
</div>
</div>

Grammuelle is a SASS minimalistic framework for building cellular designs (all 
puns intented).

## Example

Module-level interplay goes here, or meta-CSS type junk like:

1. `modules`
2. `grids`
3. `displays`
4. `hooks` (`before`, `after` order serializations)
5. `models`
6. `basics`

Generally the design ontology should be implemented within an __internal__, so 
that we provide CSS middleware from admixtures of the following:

1. [`Ifs`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L54)
2. [`Onces`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L68)
3. [`Spreads`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L75)
4. [`Classes`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L81)
5. [`Withs`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L90)
6. [`Responses`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L99-L105)
7. [`Rules`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L132)
8. [`Wraps`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L162)

## Install

    $ bower|npm install grammuelle

### Overview

`__theme__.scss` and `__interface__.scss` are good places to start. The latter is
like a `master style` booklet for your project. After you are done preparing
your grids, modules, rules, hooks, responses, etc., `import` your interface:

### Minimalism

    @import "__stylebook__";

### Maximalism

    @import "__interface__";

### Extremalism

    @import "__theme__";

## Is style for humans possible?

Probably not, but until neversville we've got non-atomic declarative CSS to 
make what's possible explicit.

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
