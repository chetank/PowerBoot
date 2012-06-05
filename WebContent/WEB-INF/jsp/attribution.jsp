<!-- 
This jsp displays the login / my account related section of the site.
It is placed on the top right section of the website
 -->

<script>
var mouse_is_inside = false;

$(document).ready(function() {
    $(".login_btn").click(function() {
        var loginBox = $("#login_box");
        if (loginBox.is(":visible"))
            loginBox.fadeOut("fast");
        else
            loginBox.fadeIn("fast");
        return false;
    });
 
    $("#login_box").hover(function(){ 
        mouse_is_inside=true; 
    }, function(){ 
        mouse_is_inside=false; 
    });
 
    $("body").click(function(){
        if(! mouse_is_inside) $("#login_box").fadeOut("fast");
    });
});
</script>
<div id="user-greeting">
    <div id="user-name"></div>
    <img id="user-picture"/>
</div>
<a class="login_btn" href="#"><span>Login</span>
	<div class="triangle"></div>
</a>
<div id="login_box">
	<div id="tab"></div>
	<div id="login_box_content">
		<form id="login_form">
			<input type="text" placeholder="Username" /> 
			<input type="password" placeholder="Password" />
			<input type="submit" value="Login" />
			<jsp:include page="includes/fbLogin.jsp"></jsp:include>
		</form>
	</div>
</div>