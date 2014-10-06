chai       = require 'chai'
{ expect } = chai
gen        = require '../lib/generator'
fs         = require 'fs'
path       = require 'path'
_          = require 'lodash'



describe 'generator =>', ->

  exists = (root, dirs...) ->
    for dir in dirs
      file = path.resolve(root, dir)
      expect(fs.existsSync(file), 'should have created file: ' + file).to.be.true

  describe 'project generation =>', ->

    createInputs = () ->
      {
        name          : 'New Npm Package'
        version       : "0.0.2"
        description   : "New npm description"
        entryPoint    : "main.js"
        testCommand   : "run-tests"
        repo          : "github://my-repo"
        keywords      : "word1 word2 word3"
        license       : "EPL"
      }

    source  = 'files/sources/t1'
    target  = 'files/targets/t1'
    cmd     = null

    beforeEach ->
      inputs  = createInputs()
      cmd     = _.defaults({}, { source:source, target:target }, inputs)
      gen(cmd, true)()

    it 'should create all dirs/ and files into the target dir/', ->

      base = target
      exists(base, 'package.json')

    it 'should have interpolated the projectName into the package.json file', ->

      json = fs.readFileSync(path.resolve(target, 'package.json'), 'utf8')
      conf = JSON.parse(json)

      inputs = cmd
      expect(conf.name, 'missing name').to.equal(inputs.name)
      expect(conf.version, 'missing version').to.equal(inputs.version)
      expect(conf.description, 'missing description').to.equal(inputs.description)
      expect(conf.main, 'missing main').to.equal(inputs.entryPoint)
      expect(conf.scripts.test, 'missing test command').to.equal(inputs.testCommand)

    it 'should have tokenized keywords', ->
      json = fs.readFileSync(path.resolve(target, 'package.json'), 'utf8')
      conf = JSON.parse(json)
      inputs = cmd

      expect(conf.keywords).to.have.length(inputs.keywords.split(" ").length)


