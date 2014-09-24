Gen   = require 'rubber-stamp'
fs    = require 'fs'
path  = require 'path'
_     = require 'lodash'
proc  = require 'child_process'
spawn = proc.spawn


module.exports = (opts) ->
  {source, target} = opts

  inputsPackage = (inputs) ->
    name        : inputs.name
    version     : inputs.version
    description : inputs.description
    main        : inputs.entryPoint
    scripts     :
      test: inputs.testCommand or ""
    keywords    : (inputs.keywords or "").split(" ")
    license     : inputs.license or "Eclipse Public License (EPL)"
    repository  : inputs.repo

  handleClose = (next) -> (code, signal) ->
    if code isnt 0
      console.log('code', code, 'signal', signal)
    else if next? and code is 0
      next()

  createPackage = (g) ->
    model       = g.getModel()
    packageJson = inputsPackage(model)
    json        = JSON.stringify(packageJson, null, '  ')
    fs.writeFileSync(g.to('package.json'), json, 'utf8')

  installPackages = () ->
    opts  =
      cwd : path.resolve(process.cwd(), target)
      stdio : [process.stdin, process.stdout, process.stderr]

    packages =
      deps : [ 'install', 'coffee-script', 'lodash', 'nject', 'moment', '--save' ]
      devs : [ 'install', 'mocha', 'chai', 'sinon', 'sinon-chai', '--save-dev' ]

    deps = spawn("npm", packages.deps, opts)
    deps.on('exit', handleClose(->
        devs = spawn('npm', packages.devs, opts)
        devs.on('exit', handleClose(->
          git = spawn('git', ['init'], opts))
        )
      )
    )

  gen = Gen.using(source, target, opts, "Generate a rubber-stamp generator")
    .mkdir()
    .add((g) ->
      createPackage(g)
      installPackages()
      g.in(target)
        .translate('gitignore', '.gitignore')
        .translate('license', 'license')
        .translate('travis.yml', '.travis.yml')
        .process('readme.md')
        .mkdir('src', 'tests', 'files')
    )

  -> gen.apply()
