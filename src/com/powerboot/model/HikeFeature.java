package com.powerboot.model;

import java.util.List;

import de.micromata.opengis.kml.v_2_2_0.Coordinate;

public class HikeFeature {
	private String name;;
	private String marker;
	private List<Coordinate> trail;
	
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
}
