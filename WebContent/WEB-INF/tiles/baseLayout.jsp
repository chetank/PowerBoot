<%@ include file="../jsp/header.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><tiles:insertAttribute name="title" ignore="true" /></title>
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

#menu {
    float: left;
    line-height: 2em;
}

#header {
    display:block;
    height: 126px;
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
