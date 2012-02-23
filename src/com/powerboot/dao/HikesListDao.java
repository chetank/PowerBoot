package com.powerboot.dao;

import java.io.IOException;
import java.util.List;

import com.google.gdata.util.ServiceException;
import com.powerboot.dao.mapper.HikesRowMapper;
import com.powerboot.facade.GFusionFacade;
import com.powerboot.model.HikeListModel;

public class HikesListDao implements HikesListIDao {
    
    private GFusionFacade gFusionFacade;
    private static HikesListDao instance = null;
    private List<HikeListModel> hikeList = null;
    private static final String tableId = "1R9Whs_HGaUhhqE5Kkkm7-kYChn6foVLRZvQbGR8";
    private final String SELECT_ALL = "select * from " + tableId;
    
    private HikesListDao() {};
    
    public static HikesListDao getInstance() {
        if(instance == null) {
           instance = new HikesListDao();
        }
        return instance;
     }
    
    public void init() throws IOException, ServiceException {
        this.hikeList = this.gFusionFacade.executeQuery(SELECT_ALL, new HikesRowMapper());
    }
    
    
    @SuppressWarnings("unchecked")
    public List<HikeListModel> selectAll() throws IOException, ServiceException {
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
}

