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
<!-- Import Google Maps JS API V3 -->
<script type="text/javascript"
    src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDGY28fAU9jlbBlLdP9WZ7BBM6KLeslSck&sensor=true">
</script>

<!-- Import Google Earth API -->
<script type="text/javascript" src="http://www.google.com/jsapi?key=AIzaSyDGY28fAU9jlbBlLdP9WZ7BBM6KLeslSck"></script>

<!-- Import Google Places API -->
 <script src="//maps.googleapis.com/maps/api/js?sensor=false&libraries=places" type="text/javascript"></script>

<!-- Import Google-Utility libraries -->
<script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/infobubble/src/infobubble-compiled.js"></script>
<script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/googleearth/src/googleearth-compiled.js"></script>

<div id="address"><input id="searchPlaceTextField" type="text" size="100"></div>
<div id="map"></div>
<div id="trailMap"></div>

<script type="text/javascript"><!--
google.load('earth', '1');
google.maps.event.addDomListener(window, 'load', init);

/*
** Declare global variables
*/
var googleEarth;
var bounds = new google.maps.LatLngBounds();
var map;
var marker;
var originMarker;
var markersArr = [];
var infoBubbleArr = [];
var infoBubble = new InfoBubble({
maxWidth: 300
});
var point;
var infowindow = new google.maps.InfoWindow({
content: ""
});
var input = document.getElementById('searchPlaceTextField');
var autocomplete = new google.maps.places.Autocomplete(input);
var directionsDisplay = new google.maps.DirectionsRenderer();
function init() {
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 10,
        center: new google.maps.LatLng(0,0),
        mapTypeId: google.maps.MapTypeId.HYBRID
    });
    googleEarth = new GoogleEarth(map);
    google.maps.event.addListenerOnce(map, 'tilesloaded', addOverlays);

	autocomplete = new google.maps.places.Autocomplete(input);
	autocomplete.bindTo('bounds', map);
	google.maps.event.addListener(autocomplete, 'place_changed', computeDistances);
	
	originMarker = new google.maps.Marker({
	    map: map
	});
}

/*
** This method marks all the hike locations along with info-windows on the map
*/
function addOverlays() {
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
    i = ${status.count} - 1;
    var lng = parseFloat(${hike.latitude});
    var lat = parseFloat(${hike.longitude});
    var trailPoints = '${hike.trailPoints}';
    point = new google.maps.LatLng(lat,lng);

    var icon = 'resc/images/hikeMarker.gif';
    marker = new google.maps.Marker({
        position: new google.maps.LatLng(lat, lng),
        map: map,
        title: '${hike.name}',
        icon: icon
    });
    markersArr[i] = marker;

    infoBubble = new InfoBubble({
        maxWidth: 300
    });        


    infoBubble.addTab('Quick Info', '${hike.name}');
    var quickInfo = 'Distance: ' + '${hike.totalDistance}' + '<br/>';
    quickInfo += 'Duration: ' + '${hike.duration}' + '<br/>';
    quickInfo += 'Elevation Gain: ' + '${hike.elevationGain}' + '<br/>';
    infoBubble.setContent(quickInfo);

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
}

/*
 ** This method gets invoked when the user clicks on any hike from the menu list
 */
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
    menuItemSelectedStyle(i);
}

function menuItemSelectedStyle(i) {
    var menuItems = document.getElementsByName("menuItem");
    for(k = 0; k < menuItems.length; k++) {
        var menuItem = menuItems[k];
        menuItem.setAttribute("class","unselectedMenuItem");
    }
    document.getElementById("menuItem_"+i).setAttribute("class","selectedMenuItem");
}

/**
 * Compute distances between hike locations and user-entered location 
 **/

function computeDistances() {
    var place = autocomplete.getPlace();
    var origin = place.geometry.location;
    var destinations = [];
    <c:forEach items="${hikeList}" var="hike" varStatus="status">
    i = ${status.count} - 1;
    var lng = parseFloat(${hike.latitude});
    var lat = parseFloat(${hike.longitude});
    destinations[i] = new google.maps.LatLng(lat,lng);
    </c:forEach>

    originMarker.setPosition(origin);
    originMarker.setIcon(place.icon);

    var service = new google.maps.DistanceMatrixService();
    service.getDistanceMatrix(
            {
                origins: [origin],
                destinations: destinations,
                travelMode: google.maps.TravelMode.DRIVING,
                avoidHighways: false,
                avoidTolls: false
            }, callback);
}    

function callback(response, status) {
    if (status == google.maps.DistanceMatrixStatus.OK) {
        var origins = response.originAddresses;
        var destinations = response.destinationAddresses;

        for (var i = 0; i < origins.length; i++) {
            var results = response.rows[i].elements;
            for (var j = 0; j < results.length; j++) {
                var element = results[j];
                var distance = element.distance.text;
                var duration = element.duration.text;
                document.getElementById("distance_"+j).innerHTML = "(" + distance + ", " + duration + ")";
            }
        }
    }
}

function displayRouteToDestination(i) {
    if ((autocomplete.getPlace() != undefined )) {
        var directionsService = new google.maps.DirectionsService();
        var request = {
                origin:autocomplete.getPlace().geometry.location,
                destination:markersArr[i].getPosition(),
                travelMode: google.maps.TravelMode.DRIVING
        };

        directionsService.route(request, function(result, status) {
            if (status == google.maps.DirectionsStatus.OK) {
                directionsDisplay.setDirections(result);
            }
        });

        directionsDisplay.setMap(map);
        menuItemSelectedStyle(i);
    }
}
</script>

</body>
</html>