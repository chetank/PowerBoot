<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>HikeMaadi.com Welcomes You!</title>
</head>
<body>
<div style="width:900px; font-family:Arial,
sans-serif; font-size:11px; border:1px solid black">
  <table id="cm_mapTABLE"> <tbody> <tr id="cm_mapTR">

    <td> <div id="cm_map" style="width:750px; height:550px"></div> </td>
  </tr> </tbody></table>
</div>
<script src="http://maps.google.com/maps?file=api&v=2&key="
  type="text/javascript"></script>

<script type="text/javascript">
//<![CDATA[
var cm_map;
var cm_mapMarkers = [];
var cm_mapHTMLS = [];

// Create a base icon for all of our markers that specifies the
// shadow, icon dimensions, etc.
var cm_baseIcon = new GIcon();
cm_baseIcon.shadow = "http://www.google.com/mapfiles/shadow50.png";
cm_baseIcon.iconSize = new GSize(20, 34);
cm_baseIcon.shadowSize = new GSize(37, 34);
cm_baseIcon.iconAnchor = new GPoint(9, 34);
cm_baseIcon.infoWindowAnchor = new GPoint(9, 2);
cm_baseIcon.infoShadowAnchor = new GPoint(18, 25);

// Change these parameters to customize map
var param_wsId = "od6";
var param_ssKey = "0AnCRAiSCU99RdDlQb3RlMVpiMG1zeHhEcW0xdFBXWUE";
var param_useSidebar = true;
var param_titleColumn = "name";
var param_descriptionColumn = "description";
var param_latColumn = "geolongitude";
var param_lngColumn = "geolatitude";
var param_rankColumn = "";
var param_iconType = "green";
var param_iconOverType = "orange";

/**
 * Loads map and calls function to load in worksheet data.
 */
function cm_load() {
  if (GBrowserIsCompatible()) {
    // create the map
    cm_map = new GMap2(document.getElementById("cm_map"));
    cm_map.addControl(new GLargeMapControl());
    cm_map.addControl(new GMapTypeControl());
    cm_map.setCenter(new GLatLng( 43.907787,-79.359741), 2);
    cm_getJSON();
  } else {
    alert("Sorry, the Google Maps API is not compatible with this browser");
  }
}

/**
 * Function called when marker on the map is clicked.
 * Opens an info window (bubble) above the marker.
 * @param {Number} markerNum Number of marker in global array
 */
function cm_markerClicked(markerNum) {
  cm_mapMarkers[markerNum].openInfoWindowHtml(cm_mapHTMLS[markerNum]);
}

/**
 * Function that sorts 2 worksheet rows from JSON feed
 * based on their rank column. Only called if column is defined.
 * @param {rowA} Object Represents row in JSON feed
 * @param {rowB} Object Represents row in JSON feed
 * @return {Number} Difference between row values
 */
function cm_sortRows(rowA, rowB) {
  var rowAValue = parseFloat(rowA["gsx$" + param_rankColumn].$t);
  var rowBValue = parseFloat(rowB["gsx$" + param_rankColumn].$t);

  return rowAValue - rowBValue;
}

/**
 * Called when JSON is loaded. Creates sidebar if param_sideBar is true.
 * Sorts rows if param_rankColumn is valid column. Iterates through worksheet rows,
 * creating marker and sidebar entries for each row.
 * @param {JSON} json Worksheet feed
 */
function cm_loadMapJSON(json) {
  var usingRank = false;

  if(param_useSidebar == true) {
    var sidebarTD = document.createElement("td");
    sidebarTD.setAttribute("width","150");
    sidebarTD.setAttribute("valign","top");
    var sidebarDIV = document.createElement("div");
    sidebarDIV.id = "cm_sidebarDIV";
    sidebarDIV.style.overflow = "auto";
    sidebarDIV.style.height = "450px";
    sidebarDIV.style.fontSize = "12px";
    sidebarDIV.style.color = "#000000";
    sidebarTD.appendChild(sidebarDIV);
    document.getElementById("cm_mapTR").appendChild(sidebarTD);
  }

  var bounds = new GLatLngBounds();

  if(json.feed.entry[0]["gsx$" + param_rankColumn]) {
    usingRank = true;
    json.feed.entry.sort(cm_sortRows);
  }

  <c:forEach items="${hikeList}" var="hike" varStatus="i">
	  var lng = parseFloat(${hike.latitude});
	  var lat = parseFloat(${hike.longitude});
	  var point = new GLatLng(lat,lng);
	  var html = "<div style='font-size:12px'>";
	  html += "<strong>" + '${hike.name}' + "</strong>";
	  var label = '${hike.name}';
	  var rank = 50;

      // create the marker
      var marker = cm_createMarker(point,label,html,rank);
      cm_map.addOverlay(marker);
      cm_mapMarkers.push(marker);
      cm_mapHTMLS.push(html);
      bounds.extend(point);

      if(param_useSidebar == true) {
        var markerA = document.createElement("a");
        markerA.setAttribute("href","javascript:cm_markerClicked('" + '${i}' +"')");
        markerA.style.color = "#000000";
        var sidebarText= "";
        if(usingRank) {
          sidebarText += rank + ") ";
        }
        sidebarText += label;
        markerA.appendChild(document.createTextNode(sidebarText));
        sidebarDIV.appendChild(markerA);
        sidebarDIV.appendChild(document.createElement("br"));
        sidebarDIV.appendChild(document.createElement("br"));
      }
    </c:forEach>

  cm_map.setZoom(cm_map.getBoundsZoomLevel(bounds));
  cm_map.setCenter(bounds.getCenter());
}

/**
 * Creates marker with ranked Icon or blank icon,
 * depending if rank is defined. Assigns onclick function.
 * @param {GLatLng} point Point to create marker at
 * @param {String} title Tooltip title to display for marker
 * @param {String} html HTML to display in InfoWindow
 * @param {Number} rank Number rank of marker, used in creating icon
 * @return {GMarker} Marker created
 */
function cm_createMarker(point, title, html, rank) {
  var markerOpts = {};
  var nIcon = new GIcon(cm_baseIcon);

  if(rank > 0 && rank < 100) {
    nIcon.imageOut = "http://gmaps-samples.googlecode.com/svn/trunk/" +
        "markers/" + param_iconType + "/marker" + rank + ".png";
    nIcon.imageOver = "http://gmaps-samples.googlecode.com/svn/trunk/" +
        "markers/" + param_iconOverType + "/marker" + rank + ".png";
    nIcon.image = nIcon.imageOut;
  } else {
    nIcon.imageOut = "http://gmaps-samples.googlecode.com/svn/trunk/" +
        "markers/" + param_iconType + "/blank.png";
    nIcon.imageOver = "http://gmaps-samples.googlecode.com/svn/trunk/" +
        "markers/" + param_iconOverType + "/blank.png";
    nIcon.image = nIcon.imageOut;
  }

  markerOpts.icon = nIcon;
  markerOpts.title = title;
  var marker = new GMarker(point, markerOpts);

  GEvent.addListener(marker, "click", function() {
    marker.openInfoWindowHtml(html);
  });
  GEvent.addListener(marker, "mouseover", function() {
    marker.setImage(marker.getIcon().imageOver);
  });
  GEvent.addListener(marker, "mouseout", function() {
    marker.setImage(marker.getIcon().imageOut);
  });
  GEvent.addListener(marker, "infowindowopen", function() {
    marker.setImage(marker.getIcon().imageOver);
  });
  GEvent.addListener(marker, "infowindowclose", function() {
    marker.setImage(marker.getIcon().imageOut);
  });
  return marker;
}

/**
 * Creates a script tag in the page that loads in the
 * JSON feed for the specified key/ID.
 * Once loaded, it calls cm_loadMapJSON.
 */
function cm_getJSON() {

  // Retrieve the JSON feed.
  var script = document.createElement('script');

  script.setAttribute('src', 'http://spreadsheets.google.com/feeds/list'
                         + '/' + param_ssKey + '/' + param_wsId + '/public/values' +
                        '?alt=json-in-script&callback=cm_loadMapJSON');
  script.setAttribute('id', 'jsonScript');
  script.setAttribute('type', 'text/javascript');
  document.documentElement.firstChild.appendChild(script);
}

setTimeout('cm_load()', 500);

//]]>

</script>
<h1>Hike List</h1>
    <c:forEach items="${hikeList}" var="hike">
        ${hike.name}
        <br />
    </c:forEach>
</body>
</html>