package nextgenforreal.utilities.dataservice;


import java.util.Date;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;

@PersistenceCapable
public class Ticker {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private int tickerNumber;
	
	@Persistent
	private double value;
	
	public void setTickerNumber(int tickerNumber) {
		this.tickerNumber = tickerNumber;
	}
	
	public void setValue(double value) {
		this.value = value;
	}
}
