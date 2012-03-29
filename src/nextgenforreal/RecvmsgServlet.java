package nextgenforreal;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.xmpp.JID;
import com.google.appengine.api.xmpp.Message;
import com.google.appengine.api.xmpp.XMPPService;
import com.google.appengine.api.xmpp.XMPPServiceFactory;

@SuppressWarnings("serial")
public class RecvmsgServlet extends HttpServlet {
  private static final Logger logger = Logger.getLogger(
    SendmsgServlet.class.getName()
  );
  public void doPost(
    HttpServletRequest req, HttpServletResponse res
  ) throws IOException {
    XMPPService xmpp = XMPPServiceFactory.getXMPPService();
    Message msg = xmpp.parseMessage(req);
    
    JID fromJid = msg.getFromJid();
    String fromAdd = fromJid.getId().split("/")[0];
    logger.info("from: " + fromAdd);
    
    String msgbody = msg.getBody();
    logger.info("msgbody: " + msgbody);
    
    JID[] toJids = msg.getRecipientJids();
    for (JID jid : toJids) {
      logger.info("to: " + jid.getId());
    }
  }
}