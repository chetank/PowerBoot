<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp"%>
<script src="<c:url value="/resc/js/jquery.easytabs.min.js"/>"
    type="text/javascript"></script>
<script src="<c:url value="/resc/js/jcarousellite_1.0.1.min.js"/>"
    type="text/javascript"></script>
<script>
$(document).ready(function() 
        { 
            $('#tab-container').easytabs();
        } 
    );
</script>

<input type="hidden" id="hikeId" name="hikeId" value="novalue" />
<div id="hikeDetails" style="display: none">
    <div class="h2" id="hikeTitle"></div>
    <div id="basicInfo"></div>
    <div id="actionbar">
        E-mail | Print
    </div>
    <div id="images">
        <div class="gallery-wrapper">
            <div class="imageGallery">
                <ul id="featureImages"></ul>
            </div>
        </div>
        <div class="photo-slider">
            <button class="prev"></button>
            <button class="next"></button>
        </div>
    </div>
    <div id="tab-container" class="tab-container">
        <ul class='etabs'>
            <li class='tab'><a href="#Information">Information</a></li>
            <li class='tab'><a href="#Features">Features</a></li>
            <li class='tab'><a href="#Directions">Directions</a></li>
        </ul>
        <div id="Information">
            <div id="description">
                Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut 
                labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi
                ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum 
                dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia 
                deserunt mollit anim id est laborum.
            </div>
            <div id="social">
                <h3>Share with Friends</h3>
                Facebook | Twitter social plugins will go here
            </div>
            <div id="reviews">
                <h3>Reviews</h3>
                Hiker reviews will go here
            </div>
            <div id="elevation-profile">
                <h3>Elevation Profile</h3>
                <div id="chart_div" style="height: 200px"></div>
            </div>
        </div>
        <div id="Features"></div>
        <div id="Directions">Enter your location in the box above</div>
    </div>
</div>

