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

<div id="address"><input type="text" name="address" size="50"
    value="Enter your address here" />
<button>Go</button>
</div>
<div id="map"></div>
<div id="trailMap"></div>

<script>
    var bounds = new google.maps.LatLngBounds();

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 10,
      center: new google.maps.LatLng(0,0),
      mapTypeId: google.maps.MapTypeId.HYBRID
    });

    var contentString = "hello world";
    
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    var marker;
    var markersArr = [];
    var infoBubbleArr = [];
    var infoBubble = new InfoBubble({
        maxWidth: 300
      });
    var point;
    
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
        i = ${status.count} - 1;
        var lng = parseFloat(${hike.latitude});
        var lat = parseFloat(${hike.longitude});
        var trailPoints = '${hike.trailPoints}';
        point = new google.maps.LatLng(lat,lng);

        marker = new google.maps.Marker({
            position: new google.maps.LatLng(lat, lng),
            map: map,
            title: '${hike.name}'
        });
        markersArr[i] = marker;

        infoBubble = new InfoBubble({
            maxWidth: 300
          });        
        
        infoBubble.addTab('Quick Info', '${hike.name}');
        infoBubble.addTab('Trail Map', '${hike.name}');
        infoBubbleArr[i] = infoBubble;

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
                infoBubbleArr[i].open(map, marker);
                for(var j = 0; j< infoBubbleArr.length; j++) {
                       if(j!=i) {
                           infoBubbleArr[j].close(map,markersArr[j]);
                       }
                }
        }})(marker, i));
      
      bounds.extend(point);
    </c:forEach>

    map.fitBounds(bounds);

    function itemClicked(i) {     
        infoBubbleArr[i].open(map, markersArr[i]);
        for(var j = 0; j< infoBubbleArr.length; j++) {
            if(j!=i) {
                infoBubbleArr[j].close(map,markersArr[j]);
            }
        }

        map.setCenter(new google.maps.LatLng(markersArr[i].getPosition().lat(),markersArr[i].getPosition().lng()));
        map.setZoom(18);
        map.setTilt(45);

        var trailMap = new google.maps.Map(document.getElementById('trailMap'), {
            zoom: 18,
            center: new google.maps.LatLng(markersArr[i].getPosition().lat(),markersArr[i].getPosition().lng()),
            mapTypeId: google.maps.MapTypeId.SATELLITE
          });

        var points = '${hikeList[0].trailPoints}';
        var delimitedPoints = points.split("|");
        var trailPoints = [];
        for(j = 0; j < delimitedPoints.length; j++) {
            //trailPoints[0] = 123,456
            var coords = delimitedPoints[j].split(",");
            var point = new google.maps.LatLng(coords[0],coords[1]);
            trailPoints[j] = point;
        }
                                         
        var hikePath = new google.maps.Polyline({
            path: trailPoints,
            strokeColor: "#FF0000",
            strokeOpacity: 1.0,
            strokeWeight: 2
        });
        
        hikePath.setMap(map);
    }

    /**
    * Compute distances between hike locations and user-entered location 
    **/
    var origin1 = new google.maps.LatLng(13.017066,77.56704);
    var destinationA = new google.maps.LatLng(markersArr[2].getPosition().lat(), markersArr[2].getPosition().lng());
    var destinationB = new google.maps.LatLng(markersArr[3].getPosition().lat(), markersArr[3].getPosition().lng());

    var service = new google.maps.DistanceMatrixService();
    service.getDistanceMatrix(
      {
        origins: [origin1],
        destinations: [destinationA, destinationB],
        travelMode: google.maps.TravelMode.DRIVING,
        avoidHighways: false,
        avoidTolls: false
      }, callback);


    var directionsService = new google.maps.DirectionsService();
    var directionsDisplay = new google.maps.DirectionsRenderer();
    directionsDisplay = new google.maps.DirectionsRenderer();
    directionsDisplay.setMap(map);
    
    function callback(response, status) {
        if (status == google.maps.DistanceMatrixStatus.OK) {
            var origins = response.originAddresses;
            var destinations = response.destinationAddresses;
                      
            marker = new google.maps.Marker({
                position: origin1,
                map: map,
                title: 'Origin',
                animation: google.maps.Animation.DROP,
                icon: 'http://www.google.com/mapfiles/arrow.png'
            });
            
            for (var i = 0; i < origins.length; i++) {
                var results = response.rows[i].elements;
                for (var j = 0; j < results.length; j++) {
                    var element = results[j];
                    var distance = element.distance.text;
                    var duration = element.duration.text;
                    document.getElementById("distance_"+j).innerHTML = "(" + distance + ", " + duration + ")";
                    var from = origins[i];
                    var to = destinations[j];
                    calcRoute(from, to);
                }
            }            
        }
    }

    function calcRoute(start, end) {
          var request = {
            origin:start,
            destination:end,
            travelMode: google.maps.TravelMode.DRIVING
          };
          directionsService.route(request, function(result, status) {
            if (status == google.maps.DirectionsStatus.OK) {
              directionsDisplay.setDirections(result);
            }
          });
        }
  </script>
</body>
</html>