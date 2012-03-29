package nextgenforreal;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.logging.Logger;

import com.google.appengine.api.xmpp.JID;
import com.google.appengine.api.xmpp.Message;
import com.google.appengine.api.xmpp.MessageBuilder;
import com.google.appengine.api.xmpp.MessageType;
import com.google.appengine.api.xmpp.SendResponse;
import com.google.appengine.api.xmpp.XMPPService;
import com.google.appengine.api.xmpp.XMPPServiceFactory;

@SuppressWarnings("serial")
public class SendmsgServlet extends HttpServlet {
  private static final Logger logger = Logger.getLogger(
    SendmsgServlet.class.getName()
  );
  public void doPost(
    HttpServletRequest req, HttpServletResponse resp
  ) throws IOException {
    String addto = req.getParameter("addto");
    String msg = req.getParameter("msg");
    logger.info("addto: " + addto + ", msg: " + msg);

    JID jid = new JID(addto);
    XMPPService xmpp = XMPPServiceFactory.getXMPPService();
    xmpp.sendInvitation(jid);
    Message message =
      new MessageBuilder().
      withRecipientJids(jid).
      withBody(msg).
      withMessageType(MessageType.CHAT).
      build();
    boolean msgSent = false;
    SendResponse status = xmpp.sendMessage(message);
    msgSent = (status.getStatusMap().get(jid) == SendResponse.Status.SUCCESS);

    if (!msgSent) {
      logger.info("Message: " + msg + " was not sent successfully.");
    }

    resp.sendRedirect("/sendmsg.jsp");
  }
}