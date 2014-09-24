qu    = require 'inquirer'
_     = require 'lodash'
path  = require 'path'
gen   = require './generator'

###
  name (dir-name)         :
  version (0.0.0)         :
  description             :
  entry point (index.js)  :
  test command            :
  git repository          :
  keywords                :
  license (ICS)           :
  Is This OK? (yes)       :  (aborts if not yes)
###
questions = [
  {
    name    : "target"
    type    : "input"
    message : "Where would you like to write the project?"
    default : "."
  }
  {
    name    : "name"
    type    : "input"
    message : "What would you like to name the npm package?"
  }
  {
    name    : "version"
    type    : "input"
    message : "What version would you like to start the npm package as?"
    default : "0.0.1"
  }
  {
    name    : "description"
    type    : "input"
    message : "What description would you like to give the package?"
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
  }
]

qu.prompt(questions, (answers) ->
  console.log(JSON.stringify(answers, null, '  '))

  answers.source = path.resolve(__dirname, "../files/sources/t1")
  gen(answers)()
)
