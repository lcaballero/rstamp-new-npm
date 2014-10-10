Gen     = require 'rubber-stamp'
fs      = require 'fs'
path    = require 'path'
proc    = require 'child_process'
spawn   = proc.spawn
async   = require 'async'
helpers = require './helpers'


module.exports = (opts, isTesting) ->
  { hyphenatedToSymbol } = helpers
  {source, target} = opts

  inputsPackage = (inputs) ->
    name        : inputs.name
    version     : inputs.version
    description : inputs.description
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

  handleClose = (next) -> (code, signal) ->
    if code isnt 0
      console.log('code', code, 'signal', signal)
      next(new Error("code: #{code}, signal: #{signal}"))
    else if next? and code is 0
      next(null, code)

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
        .mkdir('src', 'tests', 'files')
        .copy('src/globals.coffee')
        .translate('main.coffee.ftl', "main.coffee")
        .translate('src/FirstClass.coffee.ftl', "src/#{g.getModel().symbol}.coffee")
        .translate('tests/FirstTest.coffee.ftl', "tests/#{g.getModel().symbol}Tests.coffee")
        .copy('tests/globals.coffee')
        .run(
          options:
            cwd   : path.resolve(process.cwd(), target)
            stdio : [ process.stdin, process.stdout, process.stderr ]
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
              args: [ '+x', 'main.coffee' ]
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
