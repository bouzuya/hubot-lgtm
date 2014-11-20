// Description
//   lgtm
//
// Dependencies:
//   "cheerio": "^0.17.0",
//   "q": "^1.0.1",
//   "request": "^2.37.0"
//
// Configuration:
//   None
//
// Commands:
//   hubot lgtm        - fetch an image from www.lgtm.in.
//   hubot lgtm bomb N - fetch N images from www.lgtm.in.
//
// Author:
//   bouzuya <m@bouzuya.net>
//
var Promise, cheerio, lgtm, request;

Promise = require('q').Promise;

cheerio = require('cheerio');

request = require('request');

lgtm = function(count) {
  return new Promise(function(resolve, reject) {
    var f;
    f = function(count, result) {
      if (!(count > 0)) {
        return resolve(result);
      }
      return request('http://www.lgtm.in/g', function(err, resp) {
        var $, url;
        if (err) {
          return reject(err);
        }
        $ = cheerio.load(resp.body);
        url = $('#imageUrl').val();
        result.push(url);
        return f(count - 1, result);
      });
    };
    return f(count, []);
  });
};

module.exports = function(robot) {
  return robot.respond(/lgtm(\s+bomb(\s+(\d+))?)?$/i, function(res) {
    var bomb, bombN, count;
    bomb = res.match[1];
    bombN = res.match[3];
    count = bomb == null ? 1 : bombN != null ? parseInt(bombN, 10) : 5;
    return lgtm(count).then(function(urls) {
      return res.send.apply(res, urls);
    }, function(err) {
      return res.send(err);
    });
  });
};
