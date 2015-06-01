var trello = require('node-trello');

var Trello = function(key, token) {
  var _api = new trello(key, token);

  this.onPullRequest = function(action, username, title, url, merged) {
    var regexTrelloTag = /\[\#(.*)\]/,
        regexTrelloId = /[a-zA-Z0-9,\s]+/,
        match = null,
        cards = [],
        comment = null;

    // process a title with one or more trello card IDs embedded in the format below:
    // This is an example pull request. trello card IDs within [#ZnN28vmT]
    //
    // We also support multiple car IDs in a comma separated list like this:
    // [#ZnN28vmT,Xn34vqP] or [#ZnN28vmT, Xn34vqP]
    //
    // TODO Refactor this so we can use it in places other than pull reuests
    //
    if(title) {
      match = regexTrelloTag.exec(title);
      if(match && match.length > 0) {
        match = regexTrelloId.exec(match[0]);
        if(match && match.length > 0) {
          cards = match[0].split(',');
        }
      }
    }

    switch(action) {
      case 'opened':
        comment = 'Opened ' + url + '\n' + title + ' by ' + username;
        break;
      case 'closed':
        if(merged) {
          comment = 'Merged ' + url;
        }
        break;
    }

    if(comment && cards) {
      cards.forEach(function(card) {
        var route = "/1/cards/" + card.trim() + '/actions/comments?text=' + encodeURIComponent(comment);

        _api.post(route, function(err, data) {
          if (err) {
            console.log('ERROR: ' + err);
            throw err;
          }
        });
      });
    }
  }
};

module.exports = Trello;

