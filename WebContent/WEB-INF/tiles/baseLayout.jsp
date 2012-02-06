<%@ include file="../jsp/header.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><tiles:insertAttribute name="title" ignore="true" /></title>
<link type="text/css" href="<c:url value="/resc/css/style.css" />" rel="stylesheet" />
<script type="text/javascript" src="<c:url value="/resc/js/jquery.js" />"></script>

</head>
<body>
    <div id="header"><tiles:insertAttribute name="header" /></div>
    <div id="menu"><tiles:insertAttribute name="menu" /></div>
    <div id="main"><tiles:insertAttribute name="main" /></div>
    <div id="footer"><tiles:insertAttribute name="footer" /></div>
</body>
</html>
