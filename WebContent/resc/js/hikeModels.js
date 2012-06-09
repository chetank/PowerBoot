/*
 * This class represents a hike feature.
 * The constructor initializes the member fields to empty strings
 * The setter methods are used by the client to assign values
 */

function hikeFeature() {
    this.name = null;
    this.point = null;
    this.trail = null;
    this.style = null;
    this.description = null;
    this.images = null;
    
     // SETTER METHODS FOR HIKE FEATURE OBJECT
    
     this.setName = function (name) {
         this.name = name;
     }
    
     this.setPoint = function (point) {
         this.point = point;
     }
    
     this.setTrail = function (trail) {
         this.trail = trail;
     }
    
     this.setStyle = function (style) {
         this.style = style;
     }
    
     this.setDescription = function (description) {
         this.description = description;
     }
    
     this.setImages = function (images) {
         this.images = images;
     }
    
     //END OF SETTER METHODS
}


function displayBasicHikeInfo(hikeId) {
    var hikeName = hikes[hikeId].name;
    $.getJSON("hikeDetails.htm?hikeName="+hikeName,
        function(data){
            $("<span/>", {
                text: "Elevation Gain: ",
            }).appendTo("#basicInfo");
            $("<span/>", {
                text: "None",
                class: "value",
            }).appendTo("#basicInfo");
            
            $("<br/>").appendTo("#basicInfo");
            
            $("<span/>", {
                text: "Duration: ",
            }).appendTo("#basicInfo");
            $("<span/>", {
                text: "None",
                class: "value",
            }).appendTo("#basicInfo");
            
            $("<br/>").appendTo("#basicInfo");
            
            $("<span/>", {
                text: "Summit Height: ",
            }).appendTo("#basicInfo");
            $("<span/>", {
                text: "None",
                class: "value",
            }).appendTo("#basicInfo");
            
            $("<br/>").appendTo("#basicInfo");
    });
}

var numberOfVisibleImages = 3;

function displayHikeFeaturesOnSideBar(features,hikeId) {
    $("#hikeDetails").show();
    
    //first reset the sidebar
    $("#basicInfo").text("");
    $("#Features").text("");
    
    displayBasicHikeInfo(hikeId);
    //displaySocialInfo(hikeId);
    
    for (var i = 0; i < features.length; i++) {
        var feature = features[i];
        
        //Display features on Feature Tab
        if(feature.name != "" && feature.name != null && feature.name != undefined) { 
            $("<a/>", {
                  text: feature.name,
                  href: '#',
                  onclick: 'showFeatureOnMap(' + i + ')'
                }).appendTo("#Features");
            $("<br/>").appendTo("#Features");
        }

        //Display non-trail features
        if(feature.trail == null) {
            var point = new google.maps.Marker({
                position: feature.point,
                map: map,
                title: feature.name,
                icon: feature.style,
                animation: google.maps.Animation.DROP
            });
        } else if (feature.trail.length > 0) {  //Display hike trail
            var hikePath = new google.maps.Polyline({
                path: feature.trail,
                strokeColor: "red",
                strokeOpacity: 0.7,
                strokeWeight: 2
            });
            hikePath.setMap(map);
        }
        // Display hike images
        var imageGalleryLength = $(".gallery-wrapper").width();
        $("#images").height(imageGalleryLength/(numberOfVisibleImages-1));
        $("imageGallery").width(2*(imageGalleryLength/(numberOfVisibleImages-0.5)+10));
        if(feature.images.length > 0) {
            for (var k = 0 ; k < feature.images.length ; k++) {
                var imageItem = $("<li/>").attr({
                    style: "margin-left: 2px; margin-right: 2px; margin-top: 7px"
                });
                var imageTag = $("<img/>").attr({
                    src: feature.images[k],
                    width: imageGalleryLength/(numberOfVisibleImages-0.5),
                    height: imageGalleryLength/(numberOfVisibleImages-0.5),
                    style: "border: 1px solid;"
                });
                
                imageTag.on('click', function() {
                    $el = $(this);
                    
                    var largeImage = $("<img />", {
                    
                        "src": $el.attr("src"),
                        "class": "larger"
                    
                    }).load(function() {
                        $(this)
                            .appendTo("body")
                            .width("500px")
                            .position({
                                "of": $el.find("img"),
                                "my": "center center",
                                "at": "center center",
                                "collision": "fit"
                             })
                    });
                    
                    largeImage.click(function() {
                    	$(this).remove();
                    });
                });
                
                imageTag.appendTo(imageItem);
                imageItem.appendTo("#featureImages");
            }
            
            $(".imageGallery").jCarouselLite({
                btnNext: ".next",
                btnPrev: ".prev",
                visible: numberOfVisibleImages - 1,
                start: 0,
                speed: 300,
                circular: false
            });
        }
    }
    $("#hikeTitle").html(hikes[hikeId].name);
    $("#hikeId").val(hikeId);
    displayElevationProfile(hikeId);
}

$(window).bind("resize", function(){//Adjusts image when browser resized  
	var imageGalleryLength = $(".gallery-wrapper").width();
	$(".imageGallery img").width(imageGalleryLength/(numberOfVisibleImages-0.5));
	$(".imageGallery img").height(imageGalleryLength/(numberOfVisibleImages-0.5));
	$("#featureImages li").width(imageGalleryLength/(numberOfVisibleImages-0.5));
	$("#featureImages li").height(imageGalleryLength/(numberOfVisibleImages-0.5));
    $("imageGallery").width(2*(imageGalleryLength/(numberOfVisibleImages-0.5)+10));
	$("#images").height(imageGalleryLength/(numberOfVisibleImages-1));
    $("imageGallery").width(2*(imageGalleryLength/(numberOfVisibleImages-0.5))+10);
	 });

/*
 * This method is used to display an elevation profile of the hike trail
 */

//Load the Visualization API and the columnchart package.
google.load("visualization", "1", {packages: ["columnchart"]});

//Set a callback to run when the Google Visualization API is loaded.
google.setOnLoadCallback(initialize);

var chart = null;
var elevationService = new google.maps.ElevationService();
var elevations = null;
var mousemarker = null;
function initialize() {
    chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
    
    google.visualization.events.addListener(chart, 'onmouseover', function(e) {
        if (mousemarker == null) {
          mousemarker = new google.maps.Marker({
            position: elevations[e.row].location,
            map: map,
            icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png"
          });
        } else {
          mousemarker.setPosition(elevations[e.row].location);
        }
      });
}

// define some global variables

function displayElevationProfile(hikeId) {
    elevationService.getElevationAlongPath({
        path: hikes[hikeId].trail,
        samples: 256
      }, plotElevation);
}

//Takes an array of ElevationResult objects, draws the path on the map
//and plots the elevation profile on a GViz ColumnChart
function plotElevation(results) {
    elevations = results;
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Sample');
    data.addColumn('number', 'Elevation');
    for (var i = 0; i < results.length; i++) {
        data.addRow(['', elevations[i].elevation]);
    }
    
    chart.draw(data, {
        width: 250,
        height: 200,
        legend: 'none',
        titleY: 'Elevation (m)',
        focusBorderColor: '#00ff00'
    });
}
/*
 * This class represents all the attributes for a hike.
 */

function hikeDetails() {
    this.name = null;
    this.hikeId = null;
    this.features = null;
    this.parkingPoint = null;
    this.elevationGain = null;
    this.trail = null;
    this.duration = null;
    this.difficultyLevel = null;
    this.summitHeight = null;
    this.summitMarker = null;
    
    //SETTER METHODS FOR HIKE OBJECT

    this.setName = function (name) {
        this.name = name;
    }

    this.setId = function (id) {
        this.hikeId = name;
    }

    this.setFeatures = function (features) {
        this.features = features;
    }

    this.setParkingPoint = function (parkingPoint) {
        this.parkingPoint = parkingPoint;
    }

    this.setElevationGain = function (elevationGain) {
        this.elevationGain = elevationGain;
    }

    this.setDifficultyLevel = function (difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    this.setSummitHeight = function (summit) {
        this.summit = summit;
    }
    
    this.setSummitMarker = function (summitMarker) {
        this.summitMarker = summitMarker;
    }
    
    this.setTrail = function (trail) {
        this.trail = trail;
    }
    //END OF SETTER METHODS
}






