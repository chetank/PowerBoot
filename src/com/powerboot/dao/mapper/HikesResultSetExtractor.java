package com.powerboot.dao.mapper;


import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.ResultSetExtractor;

import com.powerboot.model.HikeListModel;

public class HikesResultSetExtractor implements ResultSetExtractor {
	@Override
	public Object extractData(ResultSet rs) throws SQLException {
		HikeListModel hikes = new HikeListModel();
		hikes.setName(rs.getString(1));
		hikes.setLatitude(rs.getString(2));
		hikes.setLongitude(rs.getString(3));
		return hikes;
	}

}