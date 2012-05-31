<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp"%>
<script src="<c:url value="/resc/js/jquery.easytabs.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resc/js/jcarousellite_1.0.1.min.js"/>" type="text/javascript"></script>
<script>
$(document).ready(function() 
        { 
            $('#tab-container').easytabs();
        } 
    );
</script>

<input type="hidden" id="hikeId" name="hikeId" value="novalue"/>
<div id="hikeDetails" style="display:none">
  <div class="h2" id="hikeTitle"></div>
    <div id="tab-container" class="tab-container">
        <ul class='etabs'>
            <li class='tab'><a href="#Information">Information</a></li>
            <li class='tab'><a href="#Features">Features</a></li>
            <li class='tab'><a href="#Directions">Directions</a></li>
        </ul>
        <div id="Information">
            <div id="basicInfo"></div>
            <div id="social"></div>
            <div id="images">
                <div class="imageGallery">
                  <ul id="featureImages"></ul>
                </div>
                <button class="prev">Previous</button>
                <button class="next">Next</button>
            </div>
            <div id="chart_div" style="width:412px; height:200px"></div>
        </div>
        <div id="Features">
        </div>
        <div id="Directions">
            Enter your location in the box above
        </div>
    </div>
</div>

