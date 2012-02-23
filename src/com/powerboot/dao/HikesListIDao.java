package com.powerboot.dao;

import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import com.google.gdata.util.ServiceException;
import com.powerboot.model.HikeListModel;

public interface HikesListIDao {
	
//	void create(String name, String lat, String lon);

//	List<HikesListModel> select(String name, String lat, String lon);

	List<HikeListModel> selectAll() throws IOException, ServiceException;

//	void deleteAll();

//	void delete(String name, String lat, String lon);


}
