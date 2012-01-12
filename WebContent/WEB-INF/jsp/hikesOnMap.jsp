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

<script type="text/javascript"
	src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDGY28fAU9jlbBlLdP9WZ7BBM6KLeslSck&sensor=true">
</script>
<style type="text/css">
#map {
	height: 550px;
	width: 750px;
}
</style>
<div id="map"></div>
<link type="text/css" href="jquery-ui-1.8rc3.custom.css" rel="stylesheet" />
  <script type="text/javascript" src="jquery-1.4.2.min.js"></script>
  <script type="text/javascript" src="jquery-ui-1.8rc3.custom.min.js"></script>
<script type="text/javascript">

var contentString = [
                     '<div id="tabs">',
                     '<ul>',
                       '<li><a href="#tab-1"><span>One</span></a></li>',
                       '<li><a href="#tab-2"><span>Two</span></a></li>',
                       '<li><a href="#tab-3"><span>Three</span></a></li>',
                     '</ul>',
                     '<div id="tab-1">',
                       '<p>Tab 1</p>',
                     '</div>',
                     '<div id="tab-2">',
                      '<p>Tab 2</p>',
                     '</div>',
                     '<div id="tab-3">',
                       '<p>Tab 3</p>',
                     '</div>',
                     '</div>'
                   ].join('');



    var bounds = new google.maps.LatLngBounds();

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 10,
      center: new google.maps.LatLng(0,0),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    google.maps.event.addListener(infowindow, 'domready', function() {
        $("#tabs").tabs();
      });

    var marker;
    var markersArr = [];
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
        i = ${status.count} - 1;
        var lng = parseFloat(${hike.latitude});
        var lat = parseFloat(${hike.longitude});
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(lat, lng),
            map: map,
            title: '${hike.name}'
        });
        markersArr[i] = marker;

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
            infowindow.setContent('${hike.name}');
            infowindow.open(map, marker);
        }})(marker, i));

      var point = new google.maps.LatLng(lat,lng);
      bounds.extend(point);

    </c:forEach>

    map.fitBounds(bounds);

    function itemClicked(markerNum) {
        infowindow.setContent(markersArr[markerNum].getTitle());
        infowindow.open(map,markersArr[markerNum]);     
    }    
  </script>

</body>
</html>