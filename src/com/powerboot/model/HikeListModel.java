package com.powerboot.model;

public class HikeListModel {
	
	private String name;
	private String latitude;
	private String longitude;
	private String trailPoints;
	private String parkingPoint;
	private String trailHeadPoint;
	private int elevationGain;
	private int summitElevation;
	private int baseElevation;
	private float duration;
	private int totalDistance;
	private int parkingToTrailHeadDistance;
	private String bestTimeToVisit;
	private String specialFeatures;
	private String terrainFeatures;
	
	public String getTrailPoints() {
		return trailPoints;
	}
	public void setTrailPoints(String trailPoints) {
		this.trailPoints = trailPoints;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	
	public String getParkingPoint() {
		return parkingPoint;
	}
	public void setParkingPoint(String parkingPoint) {
		this.parkingPoint = parkingPoint;
	}
	public String getTrailHeadPoint() {
		return trailHeadPoint;
	}
	public void setTrailHeadPoint(String trailHeadPoint) {
		this.trailHeadPoint = trailHeadPoint;
	}
	public int getElevationGain() {
		return elevationGain;
	}
	public void setElevationGain(int elevationGain) {
		this.elevationGain = elevationGain;
	}
	public int getSummitElevation() {
		return summitElevation;
	}
	public void setSummitElevation(int summitElevation) {
		this.summitElevation = summitElevation;
	}
	public int getBaseElevation() {
		return baseElevation;
	}
	public void setBaseElevation(int baseElevation) {
		this.baseElevation = baseElevation;
	}
	public float getDuration() {
		return duration;
	}
	public void setDuration(float duration) {
		this.duration = duration;
	}
	public int getTotalDistance() {
		return totalDistance;
	}
	public void setTotalDistance(int totalDistance) {
		this.totalDistance = totalDistance;
	}
	public int getParkingToTrailHeadDistance() {
		return parkingToTrailHeadDistance;
	}
	public void setParkingToTrailHeadDistance(int parkingToTrailHeadDistance) {
		this.parkingToTrailHeadDistance = parkingToTrailHeadDistance;
	}
	public String getBestTimeToVisit() {
		return bestTimeToVisit;
	}
	public void setBestTimeToVisit(String bestTimeToVisit) {
		this.bestTimeToVisit = bestTimeToVisit;
	}
	public String getSpecialFeatures() {
		return specialFeatures;
	}
	public void setSpecialFeatures(String specialFeatures) {
		this.specialFeatures = specialFeatures;
	}
	public String getTerrainFeatures() {
		return terrainFeatures;
	}
	public void setTerrainFeatures(String terrainFeatures) {
		this.terrainFeatures = terrainFeatures;
	}
}
