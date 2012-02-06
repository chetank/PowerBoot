package com.powerboot.dbops;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.springframework.core.io.FileSystemResource;

import com.powerboot.model.HikeFeature;

import de.micromata.opengis.kml.v_2_2_0.Document;
import de.micromata.opengis.kml.v_2_2_0.Feature;
import de.micromata.opengis.kml.v_2_2_0.Kml;
import de.micromata.opengis.kml.v_2_2_0.LineString;
import de.micromata.opengis.kml.v_2_2_0.Placemark;
import de.micromata.opengis.kml.v_2_2_0.Point;

public class KmlParser {
    
    public static List<HikeFeature> parseKml(String filePath) throws JAXBException {
        FileSystemResource resource = new FileSystemResource(filePath);        
        File file = resource.getFile();
        
        if (!file.exists()) {
            throw new IllegalArgumentException("Did not find kml file for hike: " + resource.getPath());
        }
        
        JAXBContext jc = JAXBContext.newInstance(Kml.class);
        Unmarshaller u = jc.createUnmarshaller();
        Kml kml = (Kml) u.unmarshal(file);
        Document document = (Document) kml.getFeature();
        List<HikeFeature> hikeFeatures = new ArrayList<HikeFeature>();

        for(Feature feature : document.getFeature()) {
            if(feature instanceof Placemark) {
                HikeFeature hikeFeature = new HikeFeature();
                hikeFeature.setName(feature.getName());
                hikeFeature.setMarker(feature.getStyleUrl());
                Placemark placemark = (Placemark) feature;
                if (placemark.getGeometry() instanceof Point) {
                    Point point = (Point) placemark.getGeometry();
                    hikeFeature.setTrail(point.getCoordinates());
                } else if (placemark.getGeometry() instanceof LineString) {
                    LineString lineString = (LineString) placemark.getGeometry();
                    hikeFeature.setTrail(lineString.getCoordinates());
                }
                hikeFeatures.add(hikeFeature);
            }
        }
        
        return hikeFeatures;
    }
}
