package com.powerboot.dao;

import java.util.List;

import javax.sql.DataSource;

import com.powerboot.model.HikesListModel;

public interface HikesListIDao {
	
	void setDataSource(DataSource ds);

//	void create(String name, String lat, String lon);

//	List<HikesListModel> select(String name, String lat, String lon);

	List<HikesListModel> selectAll();

//	void deleteAll();

//	void delete(String name, String lat, String lon);


}
