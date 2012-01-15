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
<script type="text/javascript">
      var script = '<script type="text/javascript" src="http://google-maps-' +
          'utility-library-v3.googlecode.com/svn/trunk/infobubble/src/infobubble';
      if (document.location.search.indexOf('compiled') !== -1) {
        script += '-compiled';
      }
      script += '.js"><' + '/script>';
      document.write(script);
    </script>

<div id="map"></div>

<script>
    var bounds = new google.maps.LatLngBounds();

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 10,
      center: new google.maps.LatLng(0,0),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var contentString = "hello world";
    
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    var marker;
    var markersArr = [];
    var infoBubbleArr = [];
    
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
        i = ${status.count} - 1;
        var lng = parseFloat(${hike.latitude});
        var lat = parseFloat(${hike.longitude});
        var point = new google.maps.LatLng(lat,lng);

        var infoBubble = new InfoBubble({
            maxWidth: 300
          });
        
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(lat, lng),
            map: map,
            title: '${hike.name}'
        });

        markersArr[i] = marker;        

        var infoBubble = new InfoBubble({
            maxWidth: 300
          });
        
        infoBubble.addTab('Quick Info', '${hike.name}');
        infoBubble.addTab('Trail Map', '${hike.name}');
        infoBubbleArr[i] = infoBubble;

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
                infoBubbleArr[i].open(map, marker);
        }})(marker, i));
      
      bounds.extend(point);

    </c:forEach>

    map.fitBounds(bounds);

    function itemClicked(markerNum) {     
        infoBubbleArr[markerNum].open(map, markersArr[markerNum]);
    }    
  </script>
</body>
</html>