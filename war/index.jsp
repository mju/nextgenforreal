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
  </head>
  <body>
  <div>
  <%
    if (user != null) {
  %>
      <span style="margin: 10px;"><%= user.getEmail() %></span>
      <span style="margin: 10px;">
        <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>
      </span>
  <%
    } else {
  %>
      <span style="margin: 10px;">
        <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
      </span>
  <%
    }
  %>
  </div>
  <%
    if (user != null) {
  %>
  <div>
    <div>
      Send to: <input id="sendto" name="sendto" type="text">
    </div>
    <div>
      Message: <input id="msg" name="msg" type="text">
    </div>
    <div>
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
      notebook.innerHTML +=
    	  '<p><span style="font-weight: bold;">' +
    	  document.getElementById("sendto").value +
    	  ': </span>' +
    	  msg.data +
    	  '</p>';
    }
    socket.onopen = function() {
    }
    socket.onerror = function(error) {
    }
    socket.onclose = function() {
    }

    function sendMsg(email, msg) {
      var notebook = document.getElementById("notebook");
        notebook.innerHTML +=
        '<p><span style="font-weight: bold;">' +
        '<%= user.getEmail() %>: ' +
        '</span>' +
        msg +
        '</p>';
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