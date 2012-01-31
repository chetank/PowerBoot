package com.powerboot.dbops;

import java.util.List;

import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.powerboot.dao.HikesListDao;
import com.powerboot.dao.HikesListIDao;
import com.powerboot.model.HikeListModel;

public class GetHikesListFromDB {

	public static void main(String[] args) {
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
		List<HikeListModel> list = dao.selectAll();
		for (HikeListModel myHike : list) {
			System.out.print(myHike.getName() + "\n");
		}
	}
}
