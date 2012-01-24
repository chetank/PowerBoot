<%@ include file="../jsp/header.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><tiles:insertAttribute name="title" ignore="true" /></title>
<link type="text/css" href="<c:url value="/resources/css/style.css" />" rel="stylesheet" />
<img src="<c:url value="/resources/images/image.jpg" />" />
<style>
body {
    color: #555555;
    font-family: 'Open Sans',helvetica,arial,verdana,sans-serif;
    font-size: 13px;
    font-weight: normal;
    line-height: 1em;
    width: 100%;
    margin: 0 auto;
    vertical-align: baseline;
}

body a {
    text-decoration: none;
}

#main {
    width: 78%;
    float: right;
}

#menu {
    float: left;
    line-height: 2em;
    padding-right: 10px;
    margin-left: -25px;
    text-align: left;
    width: 22%;
}

#map,#map3d {
    height: 700px;
    width: 90%;
}

#address {
    padding-bottom: 10px;
}

#header {
    position: relative;
    height: 126px;
}

#headerContent {
    bottom: 0;
    text-align: center;
    padding-top: 50px;
    font-size: 27pt;
}

.distance {
    font-size: 10px;
    line-height: 1;
}

ol {
    list-style: none outside none;
}

li {
    border: solid 1px #CACACA;
    padding-left: 3px;
}

h3 {
    line-height: 0em;
} 

#footer {
    clear: both;
}

</style>
</head>
<body>
    <div id="header"><tiles:insertAttribute name="header" /></div>
    <div id="menu"><tiles:insertAttribute name="menu" /></div>
    <div id="main"><tiles:insertAttribute name="main" /></div>
    <div id="footer"><tiles:insertAttribute name="footer" /></div>
</body>
</html>
