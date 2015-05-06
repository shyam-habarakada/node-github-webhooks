# NGHWH

Node Github Web-Hooks, a simple node server for handling github webhooks.

To start the server, run

    NGHWH_HOST=localhost NGHWH_PORT=3000 NGHWH_SECRET_KEY=123 node server.sh

To expose your localhost for testing, use https://ngrok.com/

# Bookmarklet

Now that we have a way to tag github PRs with Trello shortlinks, what is the best way to get these shortlinks out of each card? Trello, as it is today, does not make this easy for you. The shortlinks are burried several clicks away, and you have to copy the full shot link URL, paste, then edit it to get the actual string for tagging in a PR. This is cumberson at best.

The bookmarket code below will help improve this situation for chrome users (it might work in other browsers -- but I have not tested it).

disclaimer: I have not tested this bookmarklet in browsers other than chrome. If you do, let me know. If you find and fix issues, definitely let me know :-)

If you dont care to look at code, visit this [JSFiddle](http://jsfiddle.net/shyamh/6k841LLu/) and simply drag the `Trello+` link to your bookmarks bar. And then use it to toggel displaying the shortlink text in each card while you are in a Trello board. To copy the text to the clipboard, simply click on that text on the card, and you have the value in your clipboard. Voila!

And here is the bookmarklet code.

```javascript
(function() {
  window.__shortlinks = (!window.__shortlinks);
  $('.list-card-title').each(function(e) {
    var el = $(this)[0];
    if(window.__shortlinks) {
      var href = el.href,
          regex = /trello\.com\/c\/(.*)\//
          shortlink = regex.exec(href)[1],
          d = document.createElement('span')
      d.innerText = shortlink;
      d.className = 'card-short-link';
      d.style.fontSize = '80%';
      d.style.marginLeft = '5px';
      d.style.padding = '1px 2px';
      d.style.color = 'rgb(221, 17, 68)';
      d.style.backgroundColor = 'rgb(247, 247, 249)';
      d.style.border = '1px solid rgb(225, 225, 232)';
      d.style.borderRadius = '3px';
      d.dataset.shortlink = shortlink;
      d.addEventListener('click',function(e) { 
        var input = document.createElement('textarea');
        document.body.appendChild(input);
        input.value = this.dataset.shortlink;
        console.log('shortlink:' + this.dataset.shortlink);
        input.focus();
        input.select();
        document.execCommand('Copy');
        input.remove();
        e.preventDefault(); 
        e.stopPropagation(); 
        return false; 
      });
      el.appendChild(d);
    } else {
      $('.card-short-link',el).remove();
    }
  });
})();
```
