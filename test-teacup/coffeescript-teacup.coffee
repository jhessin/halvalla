expect = require 'expect.js'
{renderable, render, coffeescript} = require '../lib/halvalla'

describe 'coffeescript', ->
  it 'renders script tag and javascript with coffee preamble scoped only to that javascript', ->
    template = renderable -> coffeescript -> alert 'hi'
    expected =  """<script type="text/javascript">(function() {
      var slice = [].slice,
      extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
      hasProp = {}.hasOwnProperty,
      indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };
          (function () {
            return alert(\'hi\');
          })();
    })();</script>"""
    # Equal ignoring whitespace
    expect(render(template()).replace(/[\n ]/g, '')).to.equal expected.replace(/[\n ]/g, '')

 it 'escapes the function contents for script tag', ->
    template = renderable -> coffeescript ->
      user = name: '</script><script>alert("alert");</script>'
      alert "Hello #{user.name}!"

    expect(render template()).to.contain "'<\\/script><script>alert(\"alert\");<\\/script>'"

  it 'string should render', ->
    t = -> coffeescript "alert 'hi'"
    expect(render t ).to.contain  "alert 'hi'"
  it 'comparison should render', ->
    t = -> coffeescript "alert 1>0"
    expect(render(t)).to.contain "alert 1>0"
  #it 'object should render', ->
  #  t = -> coffeescript src: 'script.coffee'
  #  expect(render(t)).to.contain "<script src=\"script.coffee\" type=\"text/coffeescript\"></script>"
