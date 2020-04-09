({
	doInit:function(component,event,helper){
		component.set("v.latitude", null);
		component.set("v.longitude", null);
		if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var lat = position.coords.latitude;
			var long = position.coords.longitude;
			console.log("userLocation: Located user at " + lat + ", " + long);
			component.set("v.latitude", lat);
			component.set("v.longitude", long);
		}, 
			function(error) {
				console.log("userLocation: Error(" + error.code + "): " + error.message);
	        });
		} else {
			console.log("userLocation: geolocation API not available");
        }
    }
})