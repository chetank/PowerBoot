package com.powerboot.dbops;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.powerboot.jdbc.JDBCConnector;

public class PopulateHikesList {

    public static void main(String[] args) {
        DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder;
        try {
            docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse (new File("BangaloreHikes.kml.xml"));
            doc.getDocumentElement ().normalize ();
            System.out.println ("Root element of the doc is " + doc.getDocumentElement().getNodeName());
            NodeList listOfHikes = doc.getElementsByTagName("Placemark");
            int totalHikes = listOfHikes.getLength();
            System.out.println("Total no of hikes : " + totalHikes);
            

            for(int s=0; s < listOfHikes.getLength() ; s++){
                Node hikePlacemark = listOfHikes.item(s);
                NodeList hikePlacemarkChildren = hikePlacemark.getChildNodes();
                String name = hikePlacemarkChildren.item(0).getNextSibling().getFirstChild().getNodeValue();
                String[] coordinates = hikePlacemarkChildren.item(7).getChildNodes().item(1).getFirstChild().getNodeValue().split(",");
                String lat = coordinates[0];
                String lon = coordinates[1];
                System.out.println("Name:" + name + " Lat:" + lat + " Lon:" + lon);
                JDBCConnector conn = new JDBCConnector();
                String query = String.format("INSERT INTO hikelist (name,geolatitude,geolongitude) VALUES ('%s', '%s', '%s')",name,lat,lon);
                conn.getStatement().executeUpdate(query);
                conn.getStatement().close();
                conn.getConnection().close();
            }    
        } catch (SAXException e) {
            System.out.print(e);
        } catch (IOException e) {
            System.out.print(e);
        } catch (ParserConfigurationException e) {
            System.out.print(e);
        } catch (SQLException e) {
            System.out.print(e);
        }
    }
}

//http://maps.googleapis.com/maps/api/staticmap?zoom=18&size=1000x1000&sensor=false&maptype=hybrid&markers=size:mid|color:blue|label:S|12.555312,77.513092|12.554574,77.512283|12.553783,77.512321
