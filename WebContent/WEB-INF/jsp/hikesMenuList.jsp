<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp"%>

<div id="sideBar">
    <ol>
        <h3>List of hikes</h3>
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
        <li id="menuItem_${status.count-1}" name="menuItem"><a href="javascript:itemClicked(${status.count-1})" onMouseOver="displayRouteToDestination(${status.count-1})">${hike.name}</a>
        <span class="distance" id="distance_${status.count-1}" ></span>
        <span id="carParkPoint_${status.count-1}" style="display:none;"></span>
        <span class="sub-menu">
	        <span id="getDirections">Directions</span>
	        <span id="getInfo">Information</span>
	        <span id="getPhotos">Photos</span>
        </span>
        </li>
    </c:forEach>
    </ol>
</div>
