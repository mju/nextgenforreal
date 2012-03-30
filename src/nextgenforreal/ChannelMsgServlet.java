package nextgenforreal;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.logging.Logger;

import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;
import com.google.appengine.api.channel.ChannelMessage;

@SuppressWarnings("serial")
public class ChannelMsgServlet extends HttpServlet {
  private static final Logger logger = Logger.getLogger(
    SendmsgServlet.class.getName()
  );
  public void doPost(
    HttpServletRequest req, HttpServletResponse resp
  ) throws IOException {
    String email = req.getParameter("e");
    logger.info("Email: " + email);
    String msg = req.getParameter("m");
    logger.info("Message: " + msg);
    ChannelService channelService = ChannelServiceFactory.getChannelService();
    channelService.sendMessage(new ChannelMessage(email, msg));
  }
}