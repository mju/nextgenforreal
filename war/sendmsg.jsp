<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<html>
  <head>
    <title>Send Message</title>
  </head>
  <body>
    <div style="font-size: 20px; margin-top: 15px; margin-bottom: 15px;">
      Use XMPP to send a message, a short one please, to somebody.
    </div>
    <form id="sendtoform" action="/sendmsg" method="post">
      <div>
        <span>Send to:</span><input id="addto" name="addto" type="text">
      </div>
      <div>
        <span>Message:</span><input id="msg" name="msg" type="text">
      </div>
      <div>
        <input type="submit" value="SEND">
      </div>
    </form>
  </body>
</html>