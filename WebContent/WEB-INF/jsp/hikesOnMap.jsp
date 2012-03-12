<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- Import Google Maps JS API V3 -->
<script type="text/javascript"
    src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDGY28fAU9jlbBlLdP9WZ7BBM6KLeslSck&sensor=true">
</script>

<!-- Import Google Earth API
<script type="text/javascript" src="http://www.google.com/jsapi?key=AIzaSyDGY28fAU9jlbBlLdP9WZ7BBM6KLeslSck"></script>
-->

<!-- Import Google Places API -->
 <script src="//maps.googleapis.com/maps/api/js?sensor=false&libraries=places" type="text/javascript"></script>

<!-- Import Google-Utility libraries -->
<script type="text/javascript" src="<c:url value="/resc/js/googleearth-compiled.js"/>"></script>

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
                        onclick="itemClicked(${status.count-1});">
                        <td class="hikeName" width="40%"><c:out value="${hike.name}" />
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

//google.load('earth', '1');
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
    //googleEarth = new GoogleEarth(map);
    google.maps.event.addListenerOnce(map, 'tilesloaded', addOverlays);
    
    autocomplete = new google.maps.places.Autocomplete(input);
    autocomplete.bindTo('bounds', map);
    google.maps.event.addListener(autocomplete, 'place_changed', computeDistances);
    
    //This event is fired when user clicks on any location on the map. We want to hide the infowindow if it is already open
    google.maps.event.addListener(map, 'click', function() {
        infowindow.close();
    });
    
    // Create the DIV to hold the control and call the ResetControl() constructor
    // passing in this DIV.
    var resetControlDiv = document.createElement('DIV');
    var resetControl = new resetControlConstructor(resetControlDiv, map);

    resetControlDiv.index = 1;
    map.controls[google.maps.ControlPosition.TOP_RIGHT].push(resetControlDiv);
    
    originMarker = new google.maps.Marker({
        map: map
    });
}

/*
 * This method marks all the hike locations along with info-windows on the map
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
                infowindow.setContent(infoWindowContent(this.getTitle(), m));
                infowindow.open(map, this);
            }
        });
    
        bounds.extend(point);
    </c:forEach>

    map.fitBounds(bounds);
}

/*
 * This method creates the HTML for the infoWindow
 */
function infoWindowContent(title, index) {
    var thumbnailDiv = "<div class='thumbnailDiv'><img class='thumbnailImage' src='<c:url value='/resc/images/thumbnail.jpg'/>'/></div>";
    var quickInfoDiv = "<div class='quickInfo'><a href='#' onclick='hikeDetailsAjax(" + index + ")'><b>" + title + "</b></a></div>";
    var infoWindowdiv = "<div class='infowindow'>" + thumbnailDiv + quickInfoDiv + "</div>";
    return infoWindowdiv;
}

/*
 * This method gets invoked when the user clicks on any hike from the menu list
 */
function itemClicked(i) {
    var hikeName = markersArr[i].getTitle();
    menuItemSelectedStyle(i);
    
    var marker = markersArr[i];
    infowindow.setContent(infoWindowContent(hikeName, i));
    infowindow.open(map, marker);
}

/*
 * This method takes a hikeId and changes the map configurations to focus on corresponding hike
 * For instance, change the map zoom level, center the map on the hike summit point
 */
function focusOnHike(i) {
    map.setCenter(new google.maps.LatLng(markersArr[i].getPosition().lat(),markersArr[i].getPosition().lng()));
    map.setZoom(14);
}

/*
 * A utility function to remove the spaces in/between hike-name words eg. Bilikal Rangaswamy Betta -> BilikalRangaswamyBetta
 */
function trimHikeName(hikeName) {
    return hikeName.replace(/\s+/g,"");
}

/*
 * This method retrieves the hike details when user clicks on a hike
 */ 
function hikeDetailsAjax(hikeId) {
    var hikeNameTrimmed = trimHikeName(markersArr[hikeId].getTitle());
    var details = "";
    $.getJSON("hikeDetails.htm?hikeName="+hikeNameTrimmed,
        function(data){
          $.each(data.details, function(i,item){
              var featureName = item.name;
              details = details + featureName + "<br/>";
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
          $("#Features").html(details);
          $("#hikeTitle").html(markersArr[hikeId].getTitle());
          $("#hikeId").val(hikeId);
        });
    focusOnHike(hikeId);
}

/*
 * This method is invoked when the user clicks on a row of the data table
 * It changes the styling of the selected row
 */
function menuItemSelectedStyle(i) {
    $("tr[name=hikeRow]").removeClass("selectedHikeRow").addClass("unselectedHikeRow");
    var hikeRowId = "hikeRow_" + i + "-" + trimHikeName(markersArr[i].getTitle());
    console.log(hikeRowId);
    $("#" + hikeRowId).removeClass("unselectedHikeRow").addClass("selectedHikeRow");
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
    //Insert new columns for distance and time to dataTable
    $("#dataTable tr:first").append("<th class='hikeInfo header'>Distance</th>");
    $("#dataTable tr:first").append("<th class='hikeInfo header'>Time</th>");
    
    //Alter column widths to create space for distance and time columns
    $('th.hikeName').css("width", "18%");
    $('td.hikeName').attr("width", "18%");
    $('th.hikeInfo').css("width", "12%");
    $('td.hikeInfo').css("width", "12%");
    
    if (status == google.maps.DistanceMatrixStatus.OK) {
        var origins = response.originAddresses;
        var destinations = response.destinationAddresses;

        for (var i = 0; i < origins.length; i++) {
            var results = response.rows[i].elements;
            for (var j = 0; j < results.length; j++) {
                var element = results[j];
                var distance = element.distance.text.split(" ")[0];
                var duration = element.duration.text;
                var rowIndex = j + 1;
                $("#dataTable tr:eq(" + rowIndex + ")").append("<td class='hikeInfo'>" + distance + "</td>");
                $("#dataTable tr:eq(" + rowIndex + ")").append("<td class='hikeInfo'>" + duration + "</td>");
            }
        }
    }
    $("#dataTable").tablesorter();
    if(($("#hikeId").val() != undefined) || ($("#hikeId").val != "")) {
        displayRouteToDestination($("#hikeId").val());
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
                $("#Directions").html("<h3><a href='#' onclick='displayDirectionsOnMap()'>Show directions on map</a> | <a href='#' onclick='hideDirectionsOnMap()'>Hide directions from map</a><br/></h3>");
                directionsDisplay.setPanel(document.getElementById("Directions"));
            }
        });
    }
}

function displayDirectionsOnMap() {
    directionsDisplay.setMap(map);
}

function hideDirectionsOnMap() {
    directionsDisplay.setMap(null);
}

/*
 * This method is invoked when the user clicks on the 'Reset button'
 */
function resetMap() {
    // call init() method again which will reset everything
    init();
}
    
/*
 * This method creates a custom map control, called 'Reset'.
 * Clicking on the reset button will bring the map back to it's original, home-page view
 */
function resetControlConstructor(controlDiv, map) {

    // Set CSS styles for the DIV containing the control
    // Setting padding to 5 px will offset the control
    // from the edge of the map.
    controlDiv.style.padding = '5px';
    
    // Set CSS for the control border.
    var controlUI = document.createElement('DIV');
    controlUI.style.backgroundColor = 'white';
    controlUI.style.borderStyle = 'solid';
    controlUI.style.borderWidth = '2px';
    controlUI.style.cursor = 'pointer';
    controlUI.style.textAlign = 'center';
    controlUI.title = 'Click to reset the map';
    controlDiv.appendChild(controlUI);
    
    // Set CSS for the control interior.
    var controlText = document.createElement('DIV');
    controlText.style.fontFamily = 'Arial,sans-serif';
    controlText.style.fontSize = '12px';
    controlText.style.paddingLeft = '4px';
    controlText.style.paddingRight = '4px';
    controlText.innerHTML = 'Reset';
    controlUI.appendChild(controlText);
    
    // Setup the click event listeners: simply set the map to Chicago.
    google.maps.event.addDomListener(controlUI, 'click', function() {
     resetMap(); 
    });
}

</script>