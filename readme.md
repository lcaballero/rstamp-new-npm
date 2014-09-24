[![Build Status](https://travis-ci.org/lcaballero/rstamp-new-npm.svg?branch=master)](https://travis-ci.org/) [![NPM version](https://badge.fury.io/js/rstamp-new-npm.svg)](http://badge.fury.io/js/rstamp-new-npm)

# Introduction


For use via `rstamp-cli`.  It generates a new npm project, one that suits my tasts, and has
a lot of libraries that I typically use.  The basic structure looks like so:

```
npm-name/
  src/
  tests/
  files/
  node_modules/
    chai/
    coffee-script/
    lodash/
    mocha/
    moment/
    nject/
    sinon/
    sinon-chai/
  package.json
  licence
  readme.md
  .travis.yml
  .gitignore

```

These default node modules are separated between development dependencies and deployment
dependencies.  The parent directory is based on the input provided when `inquirer.js`
runs obtaining input answers from the user.

## Installation

There are two way to install this generator.

### Clone and Link

You could also clone link to the npm package.  This is also typical.

```
%> git clone <this-git-url> <directory-to-clone-to>
%> cd <directory-to-clone-to>
%> npm link
```

### Globally

```
%> npm install rstamp-new-npm -g
```

## Usage

Again, `rstamp-new-npm` is intended for use with `rstamp-cli`.

```
%> rstamp -g new-npm
```

After which the generator will ask all the typical new-npm module questions and a few
specific to new-npm.


## License

See license file.

The use and distribution terms for this software are covered by the
[Eclipse Public License 1.0][EPL-1], which can be found in the file 'license' at the
root of this distribution. By using this software in any fashion, you are
agreeing to be bound by the terms of this license. You must not remove this
notice, or any other, from this software.


[EPL-1]: http://opensource.org/licenses/eclipse-1.0.txt
[new-npm]: https://github.com/lcaballero/rstamp-new-npm
