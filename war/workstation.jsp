<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <title>Workstation</title>
  <link href="style.css" rel="stylesheet" type="text/css">

  <link rel="stylesheet" type="text/css" href="NextGen/ext-4.0/resources/css/ext-all.css">
  <link rel="stylesheet" type="text/css" href="NextGen/ext-4.0/factset/portal.css">

  <script type="text/javascript" src="NextGen/ext-4.0/ext.js"></script>
  <script type="text/javascript" src="NextGen/ext-4.0/factset/cookieEditing.js"></script>
  <script type="text/javascript" src="NextGen/ext-4.0/factset/fakecontent.js"></script>
  <script type="text/javascript" src="NextGen/ext-4.0/factset/nonesense.js"></script>

  <script>
  Ext.define('Ext.app.Portal', {
      extend: 'Ext.container.Viewport',

      uses: ['Ext.app.PortalPanel', 'Ext.app.PortalColumn', 'Ext.app.GridPortlet', 'Ext.app.ChartPortlet'],
  
      getTools: function(){
        return [{
          xtype: 'tool',
          type: 'gear',
          handler: function(e, target, panelHeader, tool){
            var portlet = panelHeader.ownerCt;
            portlet.setLoading('Working...');
            Ext.defer(function() {
              portlet.setLoading(false);
            }, 2000);
          }
        }];
      },
  
        initComponent: function(){
            Ext.apply(this, {
                id: 'app-viewport',
                layout: {
                    type: 'border',
                    padding: '0 5 5 5' 
                },
                items: [{
                    id: 'app-header',
                    xtype: 'box',
                    region: 'north',
                    height: 40,
                    html: 'Workstation'
                },
                {
                    xtype: 'container',
                    region: 'center',
                    layout: 'border',
                    items: [{
                        id: 'app-options',
                        title: 'Options',
                        region: 'west',
                        animCollapse: true,
                        width: 200,
                        minWidth: 150,
                        maxWidth: 400,
                        split: true,
                        collapsible: true,
                        layoutConfig:{
                            animate: true
                        },
                        html: SettingsContent
                    },
                    {
                        id: 'app-portal',
                        xtype: 'portalpanel',
                        region: 'center',
                        items: [{
                            id: 'col-1',
                            items: [{
                                id: 'Security Lookup',
                                title: 'Security Lookup',
                                tools: this.getTools(),
                                html: SecurityLookUpApp,
                                listeners: {
                                    'close': Ext.bind(this.onPortletClose, this)
                                }
                            }]
                        },
                        {
                            id: 'col-2',
                            items: [{
                                id: 'Chat Client',
                                title: 'Chat Client',
                                tools: this.getTools(),
                                html: ChatClientApp,
                                listeners: {
                                    'close': Ext.bind(this.onPortletClose, this)
                                }
                            }]
                        },
                        {
                          id: 'col-3',
                          items: []
                        }]
                    }]
                }]
            });
            this.callParent(arguments);
        },
  
        onPortletClose: function(portlet) {
            this.showMsg('"' + portlet.title + '" was removed');
        },
  
        showMsg: function(msg) {
            var el = Ext.get('app-msg'),
                msgId = Ext.id();
  
            this.msgId = msgId;
            el.update(msg).show();
  
            Ext.defer(this.clearMsg, 3000, this, [msgId]);
        },
  
        clearMsg: function(msgId) {
            if (msgId === this.msgId) {
                Ext.get('app-msg').hide();
            }
        }
  });

  var SettingsContent = '<div class="portlet-content"><ul><li>Settings One</li><li>Settings Two</li></div>';

  var SecurityLookUpApp = '<div class="portlet-content">Security Lookup</div>';

  ///CREATE VIEW
  Ext.Loader.setPath('Ext.app', 'classes');
  Ext.require([
    'Ext.layout.container.*',
    'Ext.resizer.Splitter',
    'Ext.fx.target.Element',
    'Ext.fx.target.Component',
    'Ext.window.Window',
    'Ext.app.Portlet',
    'Ext.app.PortalColumn',
    'Ext.app.PortalPanel',
    'Ext.app.Portlet',
    'Ext.app.PortalDropZone',
    'Ext.app.GridPortlet',
    'Ext.app.ChartPortlet'
  ]);

  Ext.onReady(function(){
    Ext.create('Ext.app.Portal');
  });
  </script>
</head>
<body>
  <div id="chat_wrapper">
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
  </div>
  <script type="text/javascript">
    var chatter = document.getElementById("chat_wrapper");
    window.alert(chatter.innerHTML);
    var ChatClientApp = chatter.innerHTML;
    //var ChatClientApp = '<div class="portlet-content">Security Lookup</div>';
    chatter.innerHTML = "";
  </script>
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
      //var path = "http://nextgenforreal.appspot.com/channelmsg?e=" + email + "&m=" + msg;
      var path = "http://localhost:8888/channelmsg?e=" + email + "&m=" + msg;
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