package com.powerboot.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBException;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.mvc.Controller;

import com.powerboot.dbops.KmlParser;
import com.powerboot.model.HikeFeature;

public class HikeDetailsController extends AbstractController implements Controller {

    private String hikeName = "";
    private String dirLocation = "resc/kml/";

    public ModelAndView handleRequest(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        
        this.hikeName = request.getParameter("hikeName");
        if(this.hikeName == null) {
            throw new IllegalArgumentException("Value of request parameter, hike name, is null or empty");
        }
        
        String filePath = this.getServletContext().getRealPath(dirLocation + hikeName + ".xml");
        
        List<HikeFeature> hikeFeatures;
        try {

            hikeFeatures = KmlParser.parseKml(filePath);
            Map<String, List<HikeFeature>> hikeDetails = new HashMap<String,List<HikeFeature>>();
            hikeDetails.put("details",hikeFeatures);
            return new ModelAndView("jsonView", hikeDetails);

        } catch (JAXBException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return null;
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
}