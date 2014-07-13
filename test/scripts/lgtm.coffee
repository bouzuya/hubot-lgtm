require '../helper'

describe 'xxx', ->
  beforeEach (done) ->
    @kakashi.scripts = [require '../../src/scripts/lgtm']
    @kakashi.users = [{ id: 'bouzuya', room: 'hitoridokusho' }]
    @kakashi.start().then done, done
    @pattern = new RegExp('^https?://.*\\.(png|gif|jpe?g)(\\?.*)?$', 'i')

  afterEach (done) ->
    @kakashi.stop().then done, done

  describe 'receive "@hubot lgtm"', ->
    it 'send "http://..." (image url)', (done) ->
      sender = id: 'bouzuya', room: 'hitoridokusho'
      message = '@hubot lgtm'
      @timeout 5000
      @kakashi
        .timeout 5000
        .receive sender, message
        .then =>
          expect(@kakashi.send.callCount).to.equal(1)
          expect(@kakashi.send.firstCall.args[1]).to.match(@pattern)
        .then (-> done()), done

  describe 'receive "@hubot lgtm bomb"', ->
    it 'send "http://..." (image url) 5 urls', (done) ->
      sender = id: 'bouzuya', room: 'hitoridokusho'
      message = '@hubot lgtm bomb'
      @timeout 5000
      @kakashi
        .timeout 5000
        .receive sender, message
        .then =>
          expect(@kakashi.send.callCount).to.equal(1)
          expect(@kakashi.send.firstCall.args[1]).to.match(@pattern)
          expect(@kakashi.send.firstCall.args[2]).to.match(@pattern)
          expect(@kakashi.send.firstCall.args[3]).to.match(@pattern)
          expect(@kakashi.send.firstCall.args[4]).to.match(@pattern)
          expect(@kakashi.send.firstCall.args[5]).to.match(@pattern)
        .then (-> done()), done

  describe 'receive "@hubot lgtm bomb 2"', ->
    it 'send "http://..." (image url) 2 urls', (done) ->
      sender = id: 'bouzuya', room: 'hitoridokusho'
      message = '@hubot lgtm bomb 2'
      @timeout 5000
      @kakashi
        .timeout 5000
        .receive sender, message
        .then =>
          pattern = new RegExp('^https?://.*\.(png|gif|jpe?g)$', 'i')
          expect(@kakashi.send.callCount).to.equal(1)
          expect(@kakashi.send.firstCall.args[1]).to.match(@pattern)
          expect(@kakashi.send.firstCall.args[2]).to.match(@pattern)
        .then (-> done()), done
