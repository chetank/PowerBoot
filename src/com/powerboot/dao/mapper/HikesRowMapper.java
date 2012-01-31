package com.powerboot.dao.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class HikesRowMapper implements RowMapper {

	@Override
	public Object mapRow(ResultSet rs, int line) throws SQLException {
		HikesResultSetExtractor extractor = new HikesResultSetExtractor();
		return extractor.extractData(rs);
	}

}