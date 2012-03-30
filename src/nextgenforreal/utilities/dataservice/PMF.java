package nextgenforreal.utilities.dataservice;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManagerFactory;

public final class PMF {
	private PMF() {}
	
	public static PersistenceManagerFactory get() {
		return pmfInstance;
	}
	
	private static final PersistenceManagerFactory pmfInstance = 
			JDOHelper.getPersistenceManagerFactory("transactions-optional");
}
