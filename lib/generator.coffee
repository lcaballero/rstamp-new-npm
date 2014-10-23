Gen     = require 'rubber-stamp'
fs      = require 'fs'
path    = require 'path'
proc    = require 'child_process'
spawn   = proc.spawn
async   = require 'async'
helpers = require './helpers'
_       = require 'lodash'


module.exports = (opts, isTesting) ->
  { hyphenatedToSymbol } = helpers
  { source, target } = opts

  inputsPackage = (inputs) ->
    name        : inputs.name
    version     : inputs.version
    description : inputs.description
    author      : inputs.author
    main        : inputs.entryPoint
    keywords    : do ->
      keywords = _.compact((inputs.keywords or "").split(" "))
      if keywords.length > 0
        keywords
      else
        []
    license     : inputs.license or "Eclipse Public License (EPL)"
    repository  : inputs.repo
    scripts     :
      test: inputs.testCommand or ""

  createPackage = (g) ->
    model       = g.getModel()
    packageJson = inputsPackage(model)
    json        = JSON.stringify(packageJson, null, '  ')
    fs.writeFileSync(g.to('package.json'), json, 'utf8')

  opts.symbol = hyphenatedToSymbol(opts.name)

  gen = Gen.using(source, target, opts, "Generate a new Node npm package.")
    .mkdir()
    .add((g) ->
      createPackage(g)

      g.translate('gitignore', '.gitignore')
        .translate('license', 'license')
        .translate('travis.yml', '.travis.yml')
        .process('readme.md')
        .mkdirs('src', 'tests', 'files')
        .translate('index.js.ftl', opts.entryPoint)
        .translate('src/FirstClass.coffee.ftl', "src/#{g.getModel().symbol}.coffee")
        .translate('tests/FirstTest.coffee.ftl', "tests/#{g.getModel().symbol}Tests.coffee")
        .copy('tests/globals.coffee')
        .run(
          commands :
            if isTesting then []
            else [
              name: 'npm'
              args: [ 'install', 'coffee-script', 'lodash', 'nject', 'moment', '--save' ]
            ,
              name: 'npm'
              args: [ 'install', 'mocha', 'chai', 'sinon', 'sinon-chai', '--save-dev' ]
            ,
              name: 'git'
              args: [ 'init' ]
            ,
              name: 'chmod',
              args: [ '+x', opts.entryPoint ]
            ,
              name: 'npm'
              args: [ 'test' ]
            ]
        )
    )

  ->
    nogen = path.resolve(opts.target, ".rstamp.nogen")

    if fs.existsSync(nogen)
      console.log("#{nogen} file is present in target directory.")
      console.log("Aborting generation.")
    else
      gen.apply()
