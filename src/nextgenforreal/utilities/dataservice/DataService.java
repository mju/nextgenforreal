package nextgenforreal.utilities.dataservice;

import java.util.LinkedList;
import java.util.Random;

import org.mortbay.log.*;
import java.util.logging.Logger;
import java.util.logging.Level;

import javax.jdo.PersistenceManager;
import javax.jdo.Transaction;

import com.google.appengine.api.datastore.KeyFactory;

public class DataService {
	//ONLY CALLED ONCE
	public static void initializeMockData() {
		logger.info("Starting to generate data.");
		LinkedList<Company> companies = new LinkedList<Company>();
		PersistenceManager pm = PMF.get().getPersistenceManager();
		
		try
		{
			for(long i = 1; i <= 100; i++) {
				Company mockCompanyX = new Company();
				int weight = rand.nextInt(100);
				double price = rand.nextFloat();
				
				//mockCompanyX.setKey(KeyFactory.createKey(Company.class.getSimpleName(), i));
				mockCompanyX.setFullCompanyName("Company " + i);
				mockCompanyX.setMarketCap(rand.nextDouble()*99999*weight); 
				mockCompanyX.setShares(rand.nextInt(1000000) + 2435);
				mockCompanyX.setTickerSymbol("CP" + i);
				mockCompanyX.setGrowthMagnitude(rand.nextInt(30));
				mockCompanyX.setGrowthProbability(rand.nextDouble());
				mockCompanyX.setPrice((price > .01)? (price*weight*100) : 20);
				
				companies.add(mockCompanyX);
				logger.info("Finished generating data for Company " + i);
			}
			
			logger.info("Saving mock data to db");
			
			
			pm.makePersistentAll(companies);
			
			logger.info("Mock data initialized");
		} finally {
			pm.close();
		}
	}
	
	protected static double updateCompany(Company company) {
		double price = company.getPrice();
		double gP = company.getGrowthProbability();
		double gM = company.getGrowthMagnitude();
		double growth =  gM * ((gP > rand.nextDouble()) ? 1 : -1);
		
		double newPrice = growth + price;
		if( newPrice > 0 ) {
			company.setPrice(newPrice);
			logger.info("New price calculated for company: " + company.getCompanyName());
			
			return newPrice;
		}
		logger.info("Did not update.");
		
		return price;
	}
	
	private static Random rand = new Random();
	private static Logger logger = Logger.getLogger(DataService.class.getName());
}
