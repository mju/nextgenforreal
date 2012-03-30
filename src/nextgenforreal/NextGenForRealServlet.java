package nextgenforreal;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.logging.Logger;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;

@SuppressWarnings("serial")
public class NextGenForRealServlet extends HttpServlet {
  private static final Logger logger = Logger.getLogger(
    SendmsgServlet.class.getName()
  );
  public void doGet(
    HttpServletRequest req, HttpServletResponse resp
  ) throws IOException {
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null) {
      logger.info("Nickname: " + user.getNickname());
      logger.info("Email: " + user.getEmail());
      logger.info("UserId: " + user.getUserId());
      
      // set up the channel for this client.
      ChannelService channelService =
        ChannelServiceFactory.getChannelService();
      String token = channelService.createChannel(user.getUserId());
      resp.getWriter().write(token);
    } else {
      resp.sendRedirect(
        userService.createLoginURL(req.getRequestURI())
      );
    }
  }
}