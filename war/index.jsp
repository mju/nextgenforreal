<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="java.util.logging.Logger" %>

<%@ page import="com.google.appengine.api.channel.ChannelService" %>
<%@ page import="com.google.appengine.api.channel.ChannelServiceFactory" %>

<%
  UserService userService = UserServiceFactory.getUserService();
  User user = userService.getCurrentUser();
  Logger logger = Logger.getLogger(this.getClass().getName());
  String token = null;
  if (user != null) {
    // set up the channel
    logger.info("Nickname: " + user.getNickname());
    logger.info("Email: " + user.getEmail());
    logger.info("UserId: " + user.getUserId());
    
    // set up the channel for this client.
    ChannelService channelService =
      ChannelServiceFactory.getChannelService();
    token = channelService.createChannel(user.getEmail());
    logger.info("token: " + token);
  }
%>

<html>
  <head>
    <title>Next Gen For Real</title>
    <link href="style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
  <div id="login">
  <%
    if (user != null) {
  %>
      <div class="left"><%= user.getEmail() %></div>
      <div class="right">
        <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>
      </div>
  <%
    } else {
  %>
      <div>
        <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
      </div>
  <%
    }
  %>
  </div>
  <%
    if (user != null) {
  %>
  <div id="chatter">
    <div class="inputdiv">
      <label>Send to: </label><br>
      <input id="sendto" name="sendto" type="text" class="textbox" value="@gmail.com">
    </div>
    <div class="inputdiv">
      <label>Message: </label><br>
      <input id="msg" name="msg" type="text" class="textbox">
    </div>
    <div id="send_but">
      <a href="javascript: sendMsg(document.getElementById('sendto').value, document.getElementById('msg').value);">Send</a>
    </div>
    <div id="notebook"></div>
  </div>
  <script type="text/javascript" src="/_ah/channel/jsapi"></script>
  <script type="text/javascript">
    var channel = new goog.appengine.Channel("<%= token %>");
    var socket = channel.open();
    socket.onmessage = function(msg) {
      var notebook = document.getElementById("notebook");
      notebook.innerHTML =
    	  '<p><span class="bold">' +
    	  document.getElementById("sendto").value.split("@")[0] +
    	  ': </span>' +
    	  msg.data +
    	  '</p>' +
    	  notebook.innerHTML;
    }
    socket.onopen = function() {
    }
    socket.onerror = function(error) {
      window.alert("onerror: " + error.code + " " + error.description);
    }
    socket.onclose = function() {
    }

    function sendMsg(email, msg) {
      var notebook = document.getElementById("notebook");
        notebook.innerHTML =
        '<p><span class="bold">me: </span>' + msg + '</p>' + notebook.innerHTML;
      var path = "http://nextgenforreal.appspot.com/channelmsg?e=" + email + "&m=" + msg;
      //var path = "http://localhost:8888/channelmsg?e=" + email + "&m=" + msg;
      var xhr = new XMLHttpRequest();
      xhr.open("POST", path, true);
      xhr.send();
    }
  </script>
  <%
    }
  %>
  </body>
</html>