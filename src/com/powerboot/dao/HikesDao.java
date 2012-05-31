package com.powerboot.dao;

import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import com.google.gdata.util.ServiceException;
import com.powerboot.model.HikeFeature;
import com.powerboot.model.HikeModel;

public interface HikesDao {
	
//	void create(String name, String lat, String lon);

//	List<HikesListModel> select(String name, String lat, String lon);

	public List<HikeModel> selectAll() throws IOException, ServiceException;
	
	public HikeModel getDetails(String hikeName) throws IOException, ServiceException;

	void setHikeFeatures(String hikeName, List<HikeFeature> hikeFeature);

//	void deleteAll();

//	void delete(String name, String lat, String lon);


}
