var trello = require('node-trello');

var Trello = function(key, token) {
  var _api = new trello(key, token);

  this.onPullRequest = function(url) {
    console.log(url);

    // debug
    _api.get("/1/members/me", function(err, data) {
      if (err) throw err;
      console.log(data);
    });
  }
};

module.exports = Trello;

