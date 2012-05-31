package com.powerboot.dao;

import java.io.IOException;
import java.util.List;

import com.google.gdata.util.ServiceException;
import com.powerboot.dao.mapper.HikesRowMapper;
import com.powerboot.facade.GFusionFacade;
import com.powerboot.model.HikeFeature;
import com.powerboot.model.HikeModel;

public class HikesDaoImpl implements HikesDao {
    
    private GFusionFacade gFusionFacade;
    private static HikesDaoImpl instance = null;
    private List<HikeModel> hikeList = null;
    private static final String tableId = "1R9Whs_HGaUhhqE5Kkkm7-kYChn6foVLRZvQbGR8";
    private final String SELECT_ALL = "select * from " + tableId;
    private final String SELECT_HIKE_ALL = "select * from " + tableId + "where name=";
    
    private HikesDaoImpl() {};
    
    public static HikesDaoImpl getInstance() {
        if(instance == null) {
           instance = new HikesDaoImpl();
        }
        return instance;
     }
    
    public void init() throws IOException, ServiceException {
        this.hikeList = this.gFusionFacade.executeQuery(SELECT_ALL, new HikesRowMapper());
    }
    
    
    public List<HikeModel> selectAll() throws IOException, ServiceException {
        if(this.hikeList == null) {
            this.hikeList = this.gFusionFacade.executeQuery(SELECT_ALL,
                new HikesRowMapper());
        } 
        return this.hikeList; 
    }
    
    public GFusionFacade getgFusionFacade() {
        return gFusionFacade;
    }

    public void setGFusionFacade(GFusionFacade gFusionFacade) {
        this.gFusionFacade = gFusionFacade;
    }

    @Override
    public HikeModel getDetails(String hikeName) throws IOException,
            ServiceException {
        HikeModel result = null;
        if(this.hikeList != null) {
            for(HikeModel hikeModel : this.hikeList) {
                if(hikeName.equals(hikeModel.getName())) {
                    result = new HikeModel();
                    result.setLongitude(hikeModel.getLongitude());
                    result.setLatitude(hikeModel.getLatitude());
                    result.setElevationGain(hikeModel.getElevationGain());
                    result.setDuration(hikeModel.getDuration());
                    result.setSummitElevation(hikeModel.getSummitElevation());
                    result.setName(hikeModel.getName());
                    if(hikeModel.getHikeFeatures() != null) {
                        result.setHikeFeatures(hikeModel.getHikeFeatures());
                    }
                    break;
                }
            }
        } else {
            result = new HikeModel();
            result = (HikeModel) this.gFusionFacade.executeQuery(SELECT_HIKE_ALL, new HikesRowMapper()).get(0);
        }
        return result;
    }

	@Override
	public void setHikeFeatures(String hikeName,
							   List<HikeFeature> hikeFeatures) {
		if(this.hikeList != null) {
            for(HikeModel hikeModel : this.hikeList) {
                if(hikeName.equals(hikeModel.getName())) {
                	hikeModel.setHikeFeatures(hikeFeatures);
                	break;
                }
            }
		}
	}
}

