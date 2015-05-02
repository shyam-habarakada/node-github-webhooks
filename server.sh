#!/usr/local/bin/node

var http = require('http'),
    url = require('url'),
    exec = require('child_process').exec,
    qs = require('querystring');

var host = process.env.NGHWH_HOST,
    port = process.env.NGHWH_PORT,
    thisServerUrl = "http://" + host + ":" + port,
    secret_key = process.env.NGHWH_SECRET_KEY;

process.on('uncaughtException', function (err) {
  console.log('[exception] ' + err);
});

http.createServer(function (req, res) {
  var data = "";

  req.on("data", function(chunk) {
    data += chunk;
  });

  req.on("end", function() {
    var parsedUrl = url.parse(req.url, true);
    var params = {};

    if(parsedUrl.query['secret_key'] != secret_key) {
      console.log("[warning] Unauthorized request " + req.url);
      res.writeHead(401, "Not Authorized", {'Content-Type': 'text/html'});
      res.end('401 - Not Authorized');
      return;
    }

    if(data.length > 0) {

      /* todo This code can be a lot more robust, with checks for request content type
       * and other error handling. I'm skipping that for now because I know exactly what
       * github sends in it's post recieve hooks.
       *
       * For more details see, https://help.github.com/articles/post-receive-hooks
       */

      // debugging
      console.log("[trace] data is '" + data + "'");

      params = JSON.parse(data);
      console.log(params);
    }

    res.writeHead(200, "OK", {'Content-Type': 'text/html'});
    res.end('gotcha\n');
    return;
  });

}).listen(port, host);

console.log('Server running at ' + thisServerUrl );
