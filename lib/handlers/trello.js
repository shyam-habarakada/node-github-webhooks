var Trello = function() {};

Trello.prototype.onPullRequest = function(webUrl) {
  console.log(webUrl);
}

module.exports = Trello;

