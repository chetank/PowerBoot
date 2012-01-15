<%@ include file="../jsp/header.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><tiles:insertAttribute name="title" ignore="true" /></title>
<link type="text/css" href="hikemaadistyles.css" rel="stylesheet" />
<style>
body {
    color: #555555;
    font-family: 'Open Sans',helvetica,arial,verdana,sans-serif;
    font-size: 13px;
    font-weight: normal;
    line-height: 1em;
    width: 990px;
    margin: 0 auto;
    vertical-align: baseline;
}

#map {
    height: 550px;
    width: 750px;
}

#menu {
    float: left;
    line-height: 2em;
}

#header {
    position: relative;
    height: 126px;
}

#headerContent {
    position: absolute; 
    bottom: 0;
    align: center;
}

</style>
</head>
<body>
    <div id="header"><tiles:insertAttribute name="header" /></div>
    <div id="menu"><tiles:insertAttribute name="menu" /></div>
    <div id="body"><tiles:insertAttribute name="body" /></div>
    <div id="footer"><tiles:insertAttribute name="footer" /></div>
</body>
</html>
