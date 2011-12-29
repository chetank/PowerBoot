package com.powerboot.dao.mapper;


import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.ResultSetExtractor;

import com.powerboot.model.HikesListModel;

public class HikesResultSetExtractor implements ResultSetExtractor {
	@Override
	public Object extractData(ResultSet rs) throws SQLException {
		HikesListModel hikes = new HikesListModel();
		hikes.setName(rs.getString(1));
		hikes.setLatitude(rs.getString(2));
		hikes.setLongitude(rs.getString(3));
		return hikes;
	}

}