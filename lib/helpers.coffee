

module.exports =
  hyphenatedToSymbol : (hyph) ->
    re      = /^[_a-z]|-[_a-z]/g
    hyph   ?= ""
    hyph.toLowerCase()
    .replace(re, (a) -> a.replace("-", "").toUpperCase())
    .replace("-", "")
