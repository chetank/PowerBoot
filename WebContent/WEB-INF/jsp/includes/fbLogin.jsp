<script>
        window.fbAsyncInit = function() {
          FB.init({
            appId      : '444320082247071',
            status     : true, 
            cookie     : true,
            xfbml      : true,
            oauth      : true,
          });
          
          FB.Event.subscribe('auth.login', function() {
              window.location.reload();
          });
          
          FB.getLoginStatus(function(response) {
        	  if (response.status === 'connected') {
        	    // the user is logged in and has authenticated your
        	    // app, and response.authResponse supplies
        	    // the user's ID, a valid access token, a signed
        	    // request, and the time the access token 
        	    // and signed request each expire
        	    var uid = response.authResponse.userID;
        	    var accessToken = response.authResponse.accessToken;
        	    
        	    FB.api('/me', function(user) {
                    if (user) {
                      var image = document.getElementById('user-picture');
                      image.src = 'https://graph.facebook.com/' + user.id + '/picture';
                      var name = document.getElementById('user-name');
                      name.innerHTML = user.name
                    }
                });
        	  }
        	    
        	 });
          
        };
        (function(d){
           var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
           js = d.createElement('script'); js.id = id; js.async = true;
           js.src = "//connect.facebook.net/en_US/all.js";
           d.getElementsByTagName('head')[0].appendChild(js);
         }(document));
      </script>
<div class="fb-login-button" scope="email,user_checkins">Login with Facebook</div>