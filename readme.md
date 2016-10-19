# Grammuelle

<div style="min-width: 100%; text-align: center;">
<img width="180px" src="https://raw.githubusercontent.com/nerdfiles/grammuelle/master/images/logo.png" alt="Logo" />
<div class="cite">
<i>A Grammacology of Design</i>
</div>
</div>

Grammuelle is a SASS minimalistic framework for building cellular designs (all 
puns intented).

## Example

Try

    @include Do('moduleN') {
      @include If($type: "form") {
        @include Then($type: "modal");
      };
    }

To get

    .__moduleN__ form [capabillity="cancel"] {
      background: #777; }
    .__moduleN__ form [role] {
      outline: 1px solid gold; }
    .__moduleN__ form [rel] {
      background: limegreen;
      color: #fff; }
    .__moduleN__ form [cancel] {
      color: red; }
    .__moduleN__ modal [role] {
      outline: 1px solid gold; }
    .__moduleN__ modal [rel] {
      background: limegreen;
      color: #fff; }
    .__moduleN__ modal [cancel] {
      color: red; }

Maybe

    $ npm run do.module "aNewModuleName" "background-image: url('http://placehold.it/350x150');"

To update the `__stylebook__` with

    @include Do('aNewModuleName') {
      background-image: url('http://placehold.it/350x150');
    }

Get weird

    // @fileOverview ./src/__templates__.scss
    $tachyonsOnceExample: (
      __typeplate__: (
        _extend: f6,
        _extend: grow,
        _extend: no-underline,
        _extend: br-pill,
        _extend: ph3,
        _extend: pv2,
        _extend: mb2,
        _extend: dib,
        _extend: white,
        _extend: bg-black,
      ),
    );

    // @fileOverview ./__interface__.scss

    @include Do('module__tachyonsOnceExample') {
      a { @include Once(
        $model: "anchor",
        $collection: $tachyonsOnceExample
      ) }
    }

Names are up to you. What problems are we solving?

## Problems

vjuex's `big css` problems:

### P1. Don't mess with other CSS on the page

Guard against globals:

    @include Do ... If ... Then ...

### P2. Dependencies

Pair up thematic media queries with JS expectations:

    @include Do ... Responses ...

### P3. Dead Code Elimination

See [pynaximander](https://github.com/nerdfiles/pynaximander). Otherwise

    @include Do ... With ...

encourages template sharing which can be used in build automation pruning.

### P4. Minification

Use BEM classes and reduce to hashes:

    @include Do ... Class ...

### P5. Sharing Constants between CSS and JS

    @include Do ... Once ... [getComputedStyled or requestAnimationFrame with basics]

### P6. Non-deterministic Resolution

    @include Do ... Class ...

### P7. Isolation  

    @include Do ... Rules ...

## Overview

Module-level interplay goes here, or meta-CSS type junk like:

1. `modules`
2. `grids`
3. `displays`
4. `hooks` (`before`, `after` order serializations)
5. `models`
6. `basics`

Generally the design ontology should be implemented within an __internal__, so 
that we provide CSS middleware from admixtures of the following:

1. [`Ifs`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L44)
2. [`Onces`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L50)
3. [`Spreads`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L66)
4. [`Classes`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L73)
5. [`Withs`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L91)
6. [`Responses`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L100-L106)
7. [`Wraps`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L133)
8. [`Rules`](https://github.com/nerdfiles/grammuelle/blob/master/__interface__.scss#L141)

## Install

    $ bower|npm install grammuelle

### Overview

`theme.scss` and `__interface__.scss` are good places to start. The latter is
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
