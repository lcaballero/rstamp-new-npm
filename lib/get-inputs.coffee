qu    = require 'inquirer'
path  = require 'path'
gen   = require './generator'
cls   = require 'cli-color'
_     = require 'lodash'


###
  name (dir-name)         : [.]
  version (0.0.0)         : [0.0.1]
  description             : required
  entry point (index.js)  :
  test command            :
  git repository          :
  keywords                :
  license (ICS)           :
  Is This OK? (yes)       : (aborts if not yes)
###
questions = (conf) ->
  dirName  = path.basename(process.cwd())
  [
    {
      name    : "target"
      type    : "input"
      message : "Where would you like to write the project?"
      default : '.'
    }
    {
      name    : "name"
      type    : "input"
      message : "What would you like to name the npm package?"
      default : dirName
    }
    {
      name    : "version"
      type    : "input"
      message : "What version would you like to start the npm package as?"
      default : "0.0.1"
    }
    {
      name      : "description"
      type      : "input"
      message   : "What description would you like to give the package?"
      validate  : (input) ->
        if input? and input.trim().length > 0 then true
        else "A description must be provided to properly publish to the npm registry"
    }
    {
      name    : "entryPoint"
      type    : "input"
      message : "What entry point you like to provide?"
      default : "index.js"
    }
    {
      name    : "testCommand"
      type    : "input"
      message : "The test command for the package?"
      default : "mocha --reporter list --compilers coffee:coffee-script/register tests"
    }
    {
      name    : "repo"
      type    : "input"
      message : "What is the repo for the package?"
      default :
        if conf.repoPrefix? and conf.repoPrefix.trim().length > 0
          prefix = conf.repoPrefix.replace(/\/$/, "")
          "#{prefix}/#{dirName}.git"
        else
          undefined
    }
    {
      name    : 'email'
      type    : 'input'
      message : 'What email to use for the package?'
      default : conf.email
    }
    {
      name    : 'author'
      type    : 'input'
      message : 'Author of the new package?'
      default : conf.username
    }
    {
      name    : "keywords"
      type    : "input"
      message : "What keywords do you want to use for the package?"
    }
    {
      name    : "license"
      type    : "input"
      message : "Which license would you like to use for the package?"
      default : conf.license
    }
  ]

approve = ->
  [
    {
      name    : 'approve'
      type    : 'confirm'
      message : 'Is this ok?'
    }
  ]


colors =
  name      : cls.xterm(33)
  desc      : cls.xterm(41)
  header    : cls.underline
  template  : cls.xterm(245)


padRight = (s, n) ->
  delta = Math.max(n - s.length, 0)
  s + (new Array(delta).join(' '))


showValues = (answers) ->
  keySize = _.reduce(_.keys(answers), (acc, f) ->
    Math.max(acc, f.length)
  , 0)

  valueSize = _.reduce(_.values(answers), (acc, f) ->
    Math.max(acc, f.length)
  , 0)

  keySize   += 3
  valueSize += 3

  console.log(keySize, valueSize)
  console.log(
    colors.header(padRight('Name', keySize)),
    colors.header(padRight('Value', valueSize)))

  for key,val of answers
    n = padRight(key, keySize)
    v = padRight(val, valueSize)

    console.log(colors.name(n), colors.desc(v))


module.exports = (rstampConf) ->
  qu.prompt(questions(rstampConf or {}), (answers) ->
    answers.source = path.resolve(__dirname, "../files/sources/t1")

    showValues(answers)

    qu.prompt(approve(answers), (confirmed) ->

      if confirmed.approve
        gen(answers)()
      else
        console.log("Aborted.")
    )
  )
