<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- Import Google Maps JS API V3 -->
<script type="text/javascript"
    src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDGY28fAU9jlbBlLdP9WZ7BBM6KLeslSck&sensor=true">
</script>

<!-- Import Google Earth API -->
<script type="text/javascript" src="http://www.google.com/jsapi?key=AIzaSyDGY28fAU9jlbBlLdP9WZ7BBM6KLeslSck"></script>

<!-- Import Google Places API -->
 <script src="//maps.googleapis.com/maps/api/js?sensor=false&libraries=places" type="text/javascript"></script>

<!-- Import Google-Utility libraries -->
<script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/googleearth/src/googleearth-compiled.js"></script>

<!-- Import Table Sorter API -->
<script type="text/javascript" src="<c:url value="/resc/js/jquery.tablesorter.min.js"/>"></script>

<script>
$(document).ready(function() 
        { 
            $("#dataTable").tablesorter();
        } 
    );
</script>
    <div id="map"></div>
    <div id="dataGrid">
        <table id="dataTable" class="dataTable">
            <thead>
                <tr id="dataTableHeader">
                    <th class="hikeName" width="40%">Name
                    </th>
                    <th class="hikeInfo">Elev. Gain (ft)
                    </th>
                    <th class="hikeInfo">Summit (ft)
                    </th>
                    <th class="hikeInfo">Duration (hrs)
                    </th>
                    <th class="hikeInfo">Level
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${hikeList}" var="hike" varStatus="status">
                    <c:set var="hikeNameTrimmed" value="${fn:replace(hike.name,' ','')}"></c:set>
                    <c:set var="elev" value="${status.count+1}"></c:set>
                    <tr id="hikeRow_${status.count-1}-${hikeNameTrimmed}" 
                        class="unselectedHikeRow"
                        name="hikeRow" 
                        onclick="itemClicked(${status.count-1});"
                        onMouseOver="displayRouteToDestination(${status.count-1})">
                        <td class="hikeName" width="40%"><c:out value="${hike.name}" /> 
                            <span id="distance_${status.count-1}"></span>
                            <span id="carParkPoint_${status.count-1}" style="display: none;"></span>
                        </td>
                        <td class="hikeInfo"><c:out value="${elev}"></c:out></td>
                        <td class="hikeInfo">2500</td>
                        <td class="hikeInfo">3</td>
                        <td class="hikeInfo">Easy</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

<script type="text/javascript">

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

var point;
var infowindow = new google.maps.InfoWindow({
content: ""
});
var input = document.getElementById('searchPlaceTextField');
var autocomplete = new google.maps.places.Autocomplete(input);
var directionsDisplay = new google.maps.DirectionsRenderer();
var iconImage = 'resc/images/hikeMarker.gif';
var feature = 'resc/images/feature.gif';

var icon = new google.maps.MarkerImage(
        iconImage,
        null, /* size is determined at runtime */
        null, /* origin is 0,0 */
        null, /* anchor is bottom center of the scaled image */
        new google.maps.Size(20, 24)
    );


function init() {
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 10,
        center: new google.maps.LatLng(0,0),
        mapTypeId: google.maps.MapTypeId.HYBRID
    });
    googleEarth = new GoogleEarth(map);
    google.maps.event.addListenerOnce(map, 'tilesloaded', addOverlays);
    
    //This event is fired when user clicks on any location on the map. We want to hide the infowindow if it is already open
    google.maps.event.addListenerOnce(map, 'click', function() {
        infowindow.close();
    });

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
        point = new google.maps.LatLng(lat,lng);
    
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(lat, lng),
            map: map,
            title: '${hike.name}',
            icon: icon
        });
        markersArr[i] = marker;
        
        google.maps.event.addListener(marker, 'click', function() {
            infowindow.setContent(this.getTitle());
            infowindow.open(map, this);
            var hikeRowId = "";
            for(var m = 0; m < markersArr.length; m++){
                if(markersArr[m] == this) {
                    hikeRowId = "hikeRow_" + m + "-" + trimHikeName(this.getTitle());
                    break;
                }
            }
            if(hikeRowId != "") {
                var element = document.getElementById(hikeRowId);
                element.scrollIntoView(true);
                menuItemSelectedStyle(m);
            }
        });
    
        bounds.extend(point);
    </c:forEach>

    map.fitBounds(bounds);
}

/*
 ** This method gets invoked when the user clicks on any hike from the menu list
 */
function itemClicked(i) {
    //map.setCenter(new google.maps.LatLng(markersArr[i].getPosition().lat(),markersArr[i].getPosition().lng()));
    //map.setZoom(18);
    //map.setTilt(45);
    
    var hikeName = markersArr[i].getTitle();
    menuItemSelectedStyle(i);
    
    //doAjax(hikeName,i);
    var marker = markersArr[i];
    infowindow.setContent(hikeName);
    infowindow.open(map, marker);
}

function trimHikeName(hikeName) {
    return hikeName.replace(/\s+/g,"");
}

// This method retrieves the hike details when user clicks on a hike
function doAjax(hikeName,hikeId) {
    $.getJSON("hikeDetails.htm?hikeName="+hikeName,
        function(data){
          $.each(data.details, function(i,item){
              var featureName = item.name;
              if (item.trail.length == 1) { //feature is a single point
                 var lng = item.trail[0].longitude;
                 var lat = item.trail[0].latitude;
                 var point = new google.maps.LatLng(lat, lng);
                 var feature = new google.maps.Marker({
                         position: point,
                         map: map,
                         title: featureName,
                         icon: item.style,
                         animation: google.maps.Animation.DROP
                     });
                 if(featureName == "Car Parking") {
                    $("#carParkPoint_" + hikeId).text(lat + "#" + lng);
                 }
              } else if (item.trail.length > 1) { //feature is a trail
                  var trailPoints = [];
                  for (j = 0 ; j < item.trail.length; j++) {
                      var lat = item.trail[j].latitude;
                      var lng = item.trail[j].longitude;
                      var trailPoint = new google.maps.LatLng(lat,lng);
                      trailPoints[j] = trailPoint;
                  }
                  var trailColor = item.style;
                  var hikePath = new google.maps.Polyline({
                        path: trailPoints,
                        strokeColor: "red",
                        strokeOpacity: 0.7,
                        strokeWeight: 2
                    });
                    hikePath.setMap(map);
              }
          });
        });
}

function menuItemSelectedStyle(i) {
    $("tr[name=hikeRow]").removeClass("selectedHikeRow").addClass("unselectedHikeRow");
    $("#hikeRow_" + i + "-" + trimHikeName(markersArr[i].getTitle())).removeClass("unselectedHikeRow").addClass("selectedHikeRow");
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
    var destinationCoordinates = $("#carParkPoint_" + i).text().split("#");
    var destinationPoint = new google.maps.LatLng(destinationCoordinates[0], destinationCoordinates[1]);
    if ((autocomplete.getPlace() != undefined )) {
        var directionsService = new google.maps.DirectionsService();
        var request = {
                origin:autocomplete.getPlace().geometry.location,
                destination:destinationPoint,
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