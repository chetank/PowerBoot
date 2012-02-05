package com.powerboot.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.json.simple.JSONValue;
import org.xml.sax.SAXException;

import com.powerboot.model.HikeFeature;

import de.micromata.opengis.kml.v_2_2_0.Document;
import de.micromata.opengis.kml.v_2_2_0.Feature;
import de.micromata.opengis.kml.v_2_2_0.Kml;
import de.micromata.opengis.kml.v_2_2_0.LineString;
import de.micromata.opengis.kml.v_2_2_0.Placemark;
import de.micromata.opengis.kml.v_2_2_0.Point;

public class HikeDetailsController {

	public static void main(String[] args) throws IOException, SAXException, JAXBException {

		JAXBContext jc = JAXBContext.newInstance(Kml.class);
		Unmarshaller u = jc.createUnmarshaller();
		Kml kml = (Kml) u.unmarshal(new File("BilikalRangaswamyBetta.xml"));
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

		String jsonText = JSONValue.toJSONString(hikeFeatures);
		System.out.println("==== : "+jsonText);
	}
}

/*




InputStream is =  
		this.class.getResourceAsStream("sample-xml.xml");
String xml = IOUtils.toString(is);

FileInputStream fr = new FileInputStream("BilikalRangaswamyBetta.xml");
String xml = IOUtils.toString(fr)

XMLSerializer xmlSerializer = new XMLSerializer(); 
JSON json = xmlSerializer.read( xml );  
System.out.println( json.toString(2) );




System.out.println("Found");*/
