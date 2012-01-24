<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp"%>

<div id="sideBar">
    <ol>
        <h3>List of hikes</h3>
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
        <li><a href="javascript:itemClicked(${status.count-1})" onMouseOver="displayRouteToDestination(${status.count-1})">${hike.name}</a>
        <span class="distance" id="distance_${status.count-1}" ></span>
        </li>
    </c:forEach>
    </ol>
</div>
