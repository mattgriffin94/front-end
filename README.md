front-end
=========

front-end

CS 169 Front End interacts with server to count user logins.

Please note that the Heroku server can take several seconds to boot up when you first make a request, so if when you first press a button it looks like the app is frozen for a few seconds, that's expected behavior since it's waiting for a response.  

A possible design solution would be to change our requests to be asynchronous so they don't block the main thread, but I don't want users submitting multiple request before we get a response back.
