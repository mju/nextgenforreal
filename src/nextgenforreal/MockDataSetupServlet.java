package nextgenforreal;

import nextgenforreal.utilities.dataservice.*;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.mortbay.log.Log;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class MockDataSetupServlet extends HttpServlet {
	public void doGet(
			HttpServletRequest req, HttpServletResponse resp
			) throws IOException {

		resp.setContentType("text/plain");
		
		try
		{
			DataService.initializeMockData();
			resp.getWriter().println("Finished initializing data.");
		}
		catch(Exception e) {
			logger.log(Level.SEVERE, e.toString());
			resp.getWriter().println("FAILED TO INITIALIZE DATA.");
		}
	}
	
	private static Logger logger = Logger.getLogger(MockDataSetupServlet.class.getName());
}
