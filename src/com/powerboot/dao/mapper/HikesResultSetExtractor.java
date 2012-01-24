package com.powerboot.dao.mapper;


import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.ResultSetExtractor;

import com.powerboot.model.HikeListModel;

public class HikesResultSetExtractor implements ResultSetExtractor {
    @Override
    public Object extractData(ResultSet rs) throws SQLException {
        HikeListModel hikes = new HikeListModel();
        hikes.setName(rs.getString(2));
        hikes.setLatitude(rs.getString(3));
        hikes.setLongitude(rs.getString(4));
        hikes.setTrailPoints(rs.getString(5));
        hikes.setParkingPoint(rs.getString(6));
        hikes.setElevationGain(rs.getInt(7));
        hikes.setSummitElevation(rs.getInt(8));
        hikes.setBaseElevation(rs.getInt(9));
        hikes.setDuration(rs.getFloat(10));
        hikes.setTotalDistance(rs.getInt(11));
        hikes.setParkingToTrailHeadDistance(rs.getInt(12));
        hikes.setBestTimeToVisit(rs.getString(13));
        hikes.setSpecialFeatures(rs.getString(14));
        hikes.setTerrainFeatures(rs.getString(15));
        
        return hikes;
    }
}