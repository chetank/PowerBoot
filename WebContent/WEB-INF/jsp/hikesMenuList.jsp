<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>HikeMaadi.com Welcomes You!</title>
</head>
<body>
<div id="sideBar">
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
    <a href="javascript:itemClicked(${status.count-1})">${hike.name}</a>
        <br />
    </c:forEach>
</div>
</body>
</html>