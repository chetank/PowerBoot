package com.powerboot;

import java.util.List;
import java.util.logging.Logger;

import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.web.servlet.mvc.SimpleFormController;

import com.powerboot.dao.HikesListDao;
import com.powerboot.dao.HikesListIDao;
import com.powerboot.jdbc.JDBCConnector;
import com.powerboot.model.HikeDetailsCommand;
import com.powerboot.model.HikesListModel;

public class HikesListController extends SimpleFormController {

	protected static Logger myLogger = Logger.getLogger(HikesListController.class.getName());
	private String mapUrl;

	public String getMapUrl() {
		return mapUrl;
	}
	public void setMapUrl(String mapUrl) {
		this.mapUrl = mapUrl;
	}
	
	public HikesListController() {
		HikesListIDao dao = new HikesListDao();
		// Initialize the datasource, could /should be done of Spring
		// configuration
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName("com.mysql.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql://localhost/sakila");
		dataSource.setUsername("root");
		dataSource.setPassword("test123");
		// Inject the datasource into the dao
		dao.setDataSource(dataSource);
		
		System.out.println("Now select and list all persons");
		List<HikesListModel> list = dao.selectAll();
		for (HikesListModel myHike : list) {
			System.out.print(myHike.getName() + "\n");
		}
		
		setCommandClass(HikeDetailsCommand.class);
        setCommandName("name");
    }
	

}
