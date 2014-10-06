helpers = require('../lib/helpers')

describe 'helpers-tests =>', ->

  { hyphenatedToSymbol } = helpers

  describe 'hyphenatedToSymbol =>', ->

    it 'should not fail with empty name', ->
      expect(-> hyphenatedToSymbol("")).to.not.throw(Error)

    it 'should handle null', ->
      expect(-> hyphenatedToSymbol(null)).to.not.throw(Error)

    it 'should handle undefined', ->
      expect(-> hyphenatedToSymbol(undefined)).to.not.throw(Error)

    it "should handle a hyphenated word like 'my-new-package'", ->
      name = 'my-new-package'
      expect(hyphenatedToSymbol(name)).to.equal('MyNewPackage')

    it "should handle a hyphenated word like 'my-New-Package'", ->
      name = 'my-New-Package'
      expect(hyphenatedToSymbol(name)).to.equal('MyNewPackage')

    it "should handle a hyphenated word like 'my-New-'", ->
      name = 'my-New-'
      expect(hyphenatedToSymbol(name)).to.equal('MyNew')