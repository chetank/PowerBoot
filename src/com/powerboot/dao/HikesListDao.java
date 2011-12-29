package com.powerboot.dao;

import java.util.List;
import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;

import com.powerboot.dao.mapper.HikesRowMapper;
import com.powerboot.model.HikesListModel;

public class HikesListDao implements HikesListIDao {
	private DataSource dataSource;

	public void setDataSource(DataSource ds) {
		dataSource = ds;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	/*public void create(String name, String lat, String lon) {
		JdbcTemplate insert = new JdbcTemplate(dataSource);
		insert.update("INSERT INTO PERSON (FIRSTNAME, LASTNAME) VALUES(?,?)",
				new Object[] { firstName, lastName });
	}*/
	
	public List<HikesListModel> selectAll() {
		JdbcTemplate select = new JdbcTemplate(dataSource);
		return select.query("select name, geolatitude, geolongitude from hikelist",
				new HikesRowMapper());
	}
}

