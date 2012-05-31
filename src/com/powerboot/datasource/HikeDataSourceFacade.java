package com.powerboot.datasource;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.xml.bind.JAXBException;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.google.gdata.util.ServiceException;
import com.powerboot.dao.HikesDaoImpl;
import com.powerboot.dao.HikesDao;
import com.powerboot.dbops.KmlParser;
import com.powerboot.model.HikeFeature;
import com.powerboot.model.HikeModel;

public class HikeDataSourceFacade {
    private String dirLocation = "resc/kml/";
    private ServletContext servletContext = null;
    private ApplicationContext appContext = null;

    public HikeDataSourceFacade(ApplicationContext appContext, ServletContext servletContext) {
        this.appContext = appContext;
        this.servletContext = servletContext;
    }

    public HikeModel getData(String hikeName,
            DataSourceFlavor flavor) throws IOException, ServiceException, JAXBException {

        HikeModel hikeDetails = null;
        String hikeNameTrimmed = null;
        HikesDao dao = null;
        List<HikeFeature> hikeFeatures = null;

        switch (flavor) {

        case GFUSION:
            dao = (HikesDaoImpl) appContext.getBean("hikesDAO");
            hikeDetails = dao.getDetails(hikeName);

        case KML:
            hikeNameTrimmed = hikeName.replace(" ", "");
            String filePath = servletContext.getRealPath(dirLocation + hikeNameTrimmed + ".xml");

            hikeFeatures = KmlParser.parseKml(filePath);
            hikeDetails.setHikeFeatures(hikeFeatures);

            // add hike features to hike-cache object
            dao = (HikesDaoImpl) appContext.getBean("hikesDAO");
            dao.setHikeFeatures(hikeName, hikeFeatures);

        case BOTH:
            dao = (HikesDaoImpl) appContext.getBean("hikesDAO");
            hikeDetails = dao.getDetails(hikeName);

            if(hikeDetails.getHikeFeatures() == null) {

                hikeNameTrimmed = hikeName.replace(" ", "");
                filePath = servletContext.getRealPath(dirLocation + hikeNameTrimmed + ".xml");

                hikeFeatures = KmlParser.parseKml(filePath);
                hikeDetails.setHikeFeatures(hikeFeatures);

                // add hike features to hike-cache object
                dao.setHikeFeatures(hikeName, hikeFeatures);
            }
        }

        return hikeDetails;
    }

    public ApplicationContext getAppContext() {
        return appContext;
    }

    public void setAppContext(ApplicationContext appContext) {
        this.appContext = appContext;
    }

    public ServletContext getServletContext() {
        return servletContext;
    }

    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

}
