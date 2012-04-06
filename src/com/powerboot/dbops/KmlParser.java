package com.powerboot.dbops;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.springframework.core.io.FileSystemResource;

import com.powerboot.model.HikeFeature;

import de.micromata.opengis.kml.v_2_2_0.Document;
import de.micromata.opengis.kml.v_2_2_0.Feature;
import de.micromata.opengis.kml.v_2_2_0.IconStyle;
import de.micromata.opengis.kml.v_2_2_0.Kml;
import de.micromata.opengis.kml.v_2_2_0.LineString;
import de.micromata.opengis.kml.v_2_2_0.LineStyle;
import de.micromata.opengis.kml.v_2_2_0.Placemark;
import de.micromata.opengis.kml.v_2_2_0.Point;
import de.micromata.opengis.kml.v_2_2_0.Style;
import de.micromata.opengis.kml.v_2_2_0.StyleSelector;

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

        // populate style selector map (style-id, url)
        String stylePrefix = "#";
        Map<String,String> markerMap = new HashMap<String, String>();
        List<StyleSelector> styleSelectors = document.getStyleSelector();
        for(StyleSelector styleSelector : styleSelectors) {
            if(styleSelector instanceof Style) {
                if(((Style) styleSelector).getIconStyle() != null) {
                    IconStyle iconStyle = ((Style) styleSelector).getIconStyle();
                    markerMap.put(stylePrefix + styleSelector.getId(), iconStyle.getIcon().getHref());
                } else if (((Style) styleSelector).getLineStyle() != null) {
                    LineStyle lineStyle = ((Style) styleSelector).getLineStyle();
                    markerMap.put(stylePrefix + styleSelector.getId(), lineStyle.getColor());
                }
            }
        }

        //populate list of hike features
        List<HikeFeature> hikeFeatures = new ArrayList<HikeFeature>();

        for(Feature feature : document.getFeature()) {
            if(feature instanceof Placemark) {
                HikeFeature hikeFeature = new HikeFeature();
                hikeFeature.setName(feature.getName());
                hikeFeature.setMarker(feature.getStyleUrl());
                Placemark placemark = (Placemark) feature;
                hikeFeature.setStyle(markerMap.get(placemark.getStyleUrl()));
                String description = placemark.getDescription();
                if((description != null) && (description.length() > 0)) {
                    hikeFeature.setDescription(description);
                }
                if(description.contains("<img src")) {
                    List<String> links = pullLinks(description);
                    hikeFeature.setImages(links);
                }
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
    
	private static List<String> pullLinks(String text) {
        List<String> links = new ArrayList<String>();
        String regex = "\\(?\\b(http://|www[.])[-A-Za-z0-9+&@#/%?=~_()|!:,.;]*[-A-Za-z0-9+&@#/%=~_()|]";
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(text);
        while(m.find()) {
            String urlStr = m.group();
            if (urlStr.startsWith("(") && urlStr.endsWith(")"))
            {
                urlStr = urlStr.substring(1, urlStr.length() - 1);
            }
            links.add(urlStr);
        }
        return links;
    }
}
