# Description
#   lgtm
#
# Dependencies:
#   "q": "^1.2.0",
#   "request": "^2.55.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot lgtm        - fetch an image from www.lgtm.in.
#   hubot lgtm bomb N - fetch N images from www.lgtm.in.
#
# Author:
#   bouzuya <m@bouzuya.net>
#
{Promise} = require 'q'
request = require 'request'

lgtm1 = ->
  new Promise (resolve, reject) ->
    request
      url: 'http://www.lgtm.in/g'
      headers:
        Accept: 'application/json'
      json: true
    , (err, res) ->
      return reject(err) if err?
      resolve res.body.imageUrl

lgtmN = (count) ->
  [0...count].reduce (promise, _) ->
    promise
    .then (results) ->
      lgtm1()
      .then (result) ->
        results.concat [result]
  , Promise.resolve([])

module.exports = (robot) ->
  robot.respond /lgtm(\s+bomb(\s+(\d+))?)?$/i, (res) ->
    bomb = res.match[1]
    bombN = res.match[3]
    count = unless bomb? then 1 else if bombN? then parseInt(bombN, 10) else 5

    lgtmN count
    .then (urls) ->
      res.send.apply res, urls
    .catch (e) ->
      robot.logger.error 'hubot-lgtm: error'
      robot.logger.error e
      res.send 'hubot-lgtm: error'
