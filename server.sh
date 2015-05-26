#!/usr/local/bin/node

var http = require('http'),
    url = require('url'),
    exec = require('child_process').exec,
    qs = require('querystring'),
    Trello = require('./lib/handlers/trello.js');

var host = process.env.NGHWH_HOST,
    port = process.env.NGHWH_PORT,
    thisServerUrl = "http://" + host + ":" + port,
    secretKey = process.env.NGHWH_SECRET_KEY,
    trelloKey = process.env.TRELLO_KEY,
    trelloToken = process.env.TRELLO_TOKEN,
    trello = new Trello(trelloKey, trelloToken);

process.on('uncaughtException', function (err) {
  console.log('[exception] ' + err);
  console.log(err.stack);
});

http.createServer(function (req, res) {
  var data = "";

  req.on("data", function(chunk) {
    data += chunk;
  });

  req.on("end", function() {
    try {

      var parsedUrl = url.parse(req.url, true),
          githubEvent = req.headers['x-github-event'],
          params = {};

      if(parsedUrl.query['secret_key'] != secretKey) {
        console.log("[warning] Unauthorized request " + req.url);
        res.writeHead(401, "Not Authorized", {'Content-Type': 'text/html'});
        res.end('401 - Not Authorized');
        return;
      }

      // debugging
      console.log("[trace] data is '" + data + "'");

      if(data && data.length > 0) {
        params = JSON.parse(data);
      }

      // For details, see https://developer.github.com/v3/activity/events/types/
      //
      switch(githubEvent) {
        case 'pull_request':
          console.log('action: ' + params['action']);
          console.log('user: ' + params['pull_request']['user']['login']);
          console.log('title: ' + params['pull_request']['title']);
          console.log('url: ' + params['pull_request']['html_url']);
          if(['opened','closed'].indexOf(params['action']) >= 0) {
            trello.onPullRequest( params['action'],
                                  params['pull_request']['user']['login'],
                                  params['pull_request']['title'],
                                  params['pull_request']['html_url'],
                                  params['pull_request']['merged']);
          }
          break;
        default:
          console.log('unhandled event" ' + githubEvent);
      }

      res.writeHead(200, "OK", {'Content-Type': 'text/html'});
      res.end('200 - OK');
      return;

    } catch (e) {
      console.log('[exception] ' + e);
      console.log(e.stack);
      res.writeHead(500, "Internal Server Error", {'Content-Type': 'text/html'});
      res.end('500 Internal Server Error');
    }
  });

}).listen(port, host);

console.log('Server running at ' + thisServerUrl );
