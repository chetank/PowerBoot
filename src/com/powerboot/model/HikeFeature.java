package com.powerboot.model;

import java.util.List;

import de.micromata.opengis.kml.v_2_2_0.Coordinate;

public class HikeFeature {
    private String name;
    private String marker;
    private List<Coordinate> trail;
    private String style;
    private String description;
    private List<String> images;
    
    public String getStyle() {
        return style;
    }

    public void setStyle(String style) {
        this.style = style;
    }

    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getMarker() {
        return marker;
    }
    
    public void setMarker(String marker) {
        this.marker = marker;
    }
    
    public List<Coordinate> getTrail() {
        return trail;
    }
    
    public void setTrail(List<Coordinate> trail) {
        this.trail = trail;
    }
    
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

	public List<String> getImages() {
		return images;
	}

	public void setImages(List<String> images) {
		this.images = images;
	}
}
