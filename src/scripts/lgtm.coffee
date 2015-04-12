# Description
#   lgtm
#
# Dependencies:
#   "cheerio": "^0.17.0",
#   "q": "^1.0.1",
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
cheerio = require 'cheerio'
request = require 'request'

lgtm = (count) ->
  new Promise (resolve, reject) ->
    f = (count, result) ->
      return resolve(result) unless count > 0

      request 'http://www.lgtm.in/g', (err, resp) ->
        return reject(err) if err

        $ = cheerio.load(resp.body)
        url = $('#imageUrl').val()
        result.push url

        f(count - 1, result)

    f(count, [])

module.exports = (robot) ->

  robot.respond /lgtm(\s+bomb(\s+(\d+))?)?$/i, (res) ->
    bomb = res.match[1]
    bombN = res.match[3]
    count = unless bomb? then 1 else if bombN? then parseInt(bombN, 10) else 5

    lgtm count
      .then (urls) ->
        res.send.apply res, urls
      , (err) ->
        res.send err
