package com.powerboot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.mvc.Controller;

import com.powerboot.datasource.DataSourceFlavor;
import com.powerboot.datasource.HikeDataSourceFacade;
import com.powerboot.model.HikeModel;

/**
 * @author chkumar
 *
 * This class derives the data for the hike from 2 sources:
 * 1. KML file of the hike
 * 2. Google fusion table
 * 
 * Google fusion tables have basic information for the hike, for eg., elevation gain, distance etc.
 * KML file have more in-depth information about the hike, eg., trail points, parking, features etc.
 */
public class HikeDetailsController extends AbstractController implements Controller {

    private String hikeName = "";
    private String dataSourceFlavor;

    ApplicationContext context = new ClassPathXmlApplicationContext("spring-beans.xml");

    public ModelAndView handleRequest(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        this.hikeName = request.getParameter("hikeName");
    	
    	if(this.hikeName == null) {
            throw new IllegalArgumentException("Value of request parameter, hike name, is null or empty");
        }
        
        HikeDataSourceFacade dataSourceFacade = new HikeDataSourceFacade(this.context, this.getServletContext());
        HikeModel hikeDetails = dataSourceFacade.getData(this.hikeName, DataSourceFlavor.valueOf(this.dataSourceFlavor));
        
        Map<String, HikeModel> hikeDetailsJSONMap = new HashMap<String,HikeModel>();
        hikeDetailsJSONMap.put("details",hikeDetails);
        return new ModelAndView("jsonView", hikeDetailsJSONMap);
    }

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest arg0,
            HttpServletResponse arg1) throws Exception {
        // TODO Auto-generated method stub
        return null;
    }

    public String getHikeName() {
        return hikeName;
    }

    public void setHikeName(String hikeName) {
        this.hikeName = hikeName;
    }
    
    public String getDataSourceFlavor() {
        return dataSourceFlavor;
    }

    public void setDataSourceFlavor(String dataSourceFlavor) {
        this.dataSourceFlavor = dataSourceFlavor;
    }
}