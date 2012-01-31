package com.powerboot.log;

import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Handler;

public class LoggingConfiguration {

	static Handler logFileHandler = null;
	
	private static final String logFile = "PowerBootApp";
	
	public Handler getLogFileHandler() {
		return logFileHandler;
	}

	public void setLogFileHandler(Handler logFileHandler) {
		LoggingConfiguration.logFileHandler = logFileHandler;
	}

	public static Handler getLoggingConfiguration() {
		try {
			logFileHandler = new FileHandler(logFile);
			return logFileHandler;
			
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return logFileHandler;
	}
	 
}
