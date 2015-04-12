// Description
//   lgtm
//
// Dependencies:
//   "q": "^1.2.0",
//   "request": "^2.55.0"
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
var Promise, lgtm1, lgtmN, request;

Promise = require('q').Promise;

request = require('request');

lgtm1 = function() {
  return new Promise(function(resolve, reject) {
    return request({
      url: 'http://www.lgtm.in/g',
      headers: {
        Accept: 'application/json'
      },
      json: true
    }, function(err, res) {
      if (err != null) {
        return reject(err);
      }
      return resolve(res.body.imageUrl);
    });
  });
};

lgtmN = function(count) {
  var _i, _results;
  return (function() {
    _results = [];
    for (var _i = 0; 0 <= count ? _i < count : _i > count; 0 <= count ? _i++ : _i--){ _results.push(_i); }
    return _results;
  }).apply(this).reduce(function(promise, _) {
    return promise.then(function(results) {
      return lgtm1().then(function(result) {
        return results.concat([result]);
      });
    });
  }, Promise.resolve([]));
};

module.exports = function(robot) {
  return robot.respond(/lgtm(\s+bomb(\s+(\d+))?)?$/i, function(res) {
    var bomb, bombN, count;
    bomb = res.match[1];
    bombN = res.match[3];
    count = bomb == null ? 1 : bombN != null ? parseInt(bombN, 10) : 5;
    return lgtmN(count).then(function(urls) {
      return res.send.apply(res, urls);
    })["catch"](function(e) {
      robot.logger.error('hubot-lgtm: error');
      robot.logger.error(e);
      return res.send('hubot-lgtm: error');
    });
  });
};
