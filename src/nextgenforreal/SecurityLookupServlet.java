package nextgenforreal;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SecurityLookupServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = Logger.getLogger(
			SendmsgServlet.class.getName()
	);
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		String cb = req.getParameter("callback");
		res.setContentType("application/json");
		res.setStatus(HttpServletResponse.SC_OK);
		res.getWriter().write(String.format("%s({\"securities\":[{label: \"FDS\", value: \"FDS\"},{label: \"Google\", value: \"Google\"}]})", cb));
		res.getWriter().flush();
	}
}
