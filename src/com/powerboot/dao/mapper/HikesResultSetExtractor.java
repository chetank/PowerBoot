package com.powerboot.dao.mapper;


import com.powerboot.model.HikeModel;

public class HikesResultSetExtractor  {
	
    public HikeModel extractData(String[] row)  {
        HikeModel hike = new HikeModel();
        hike.setName(row[1]);
        hike.setLatitude(row[2]);
        hike.setLongitude(row[3]);
        /*hikes.setParkingPoint(rs.getString(6));
        hikes.setElevationGain(rs.getInt(7));
        hikes.setSummitElevation(rs.getInt(8));
        hikes.setBaseElevation(rs.getInt(9));
        hikes.setDuration(rs.getFloat(10));
        hikes.setTotalDistance(rs.getInt(11));
        hikes.setParkingToTrailHeadDistance(rs.getInt(12));
        hikes.setBestTimeToVisit(rs.getString(13));
        hikes.setSpecialFeatures(rs.getString(14));
        hikes.setTerrainFeatures(rs.getString(15));*/
        
        return hike;
    }
}