$(document).ready(function() {
  console.log("WHAT UP JS!?!!??!");
  // getAllClinicsInfo();

});


// function initMap(clinicObj){
//   var customMapType = new google.maps.StyledMapType([
//       {
//         stylers: [
//           {hue: '#890000'},
//           {visibility: 'simplified'},
//           {gamma: 0.5},
//           {weight: 0.5}
//         ]
//       },
//       {
//         elementType: 'labels',
//         stylers: [{visibility: 'off'}]
//       },
//       {
//         featureType: 'water',
//         stylers: [{color: '#890000'}]
//       }
//     ], {
//       name: 'Custom Style'
//   });
//   var customMapTypeId = 'custom_style';

//   var map = new google.maps.Map(document.getElementById('map'), {
//     zoom: 4,
//     center: new google.maps.LatLng(37.09024, -95.712891),
//     mapTypeControlOptions: {
//       mapTypeIds: [google.maps.MapTypeId.ROADMAP, customMapTypeId]
//     }
//   });

//   map.mapTypes.set(customMapTypeId, customMapType);
//   map.setMapTypeId(customMapTypeId);


//   getAllClinicsInfo();
//   loadFromDB();

  // var image = 'http://i65.tinypic.com/c3ktf.jpg';

  // function createMarker(clinicObj){
  //   var clinicLoc = { lat: clinicObj.lat, lng: clinicObj.lng };
  //   var marker = new google.maps.Marker({
  //     position: clinicLoc,
  //     map: map,
  //     // animation: google.maps.Animation.DROP,
  //     title: clinicObj.name,
  //     // icon: image
  //   });
  // }


// function to retrieve geolocation data from already formed DB
  // function loadFromDB(){
  //   $.get("/clinicsLocations", function(response){
  //     var arrayClinicObjects = jQuery.parseJSON(response);
  //     var clinicCount = arrayClinicObjects.length;

  //     for (var i=1; i < clinicCount; i++){
  //       console.log("FOR");

  //       arrayClinicObjects[i].lat = parseFloat(arrayClinicObjects[i].lat)
  //       arrayClinicObjects[i].lng = parseFloat(arrayClinicObjects[i].lng)

  //       createMarker(arrayClinicObjects[i]);
  //     }
  //   })
  // }


  // functions to get and save geolocation coordinates below here
  function getAllClinicsInfo(){
    $.get("/clinicsLocations", function(response){
      console.log(response);
      var arrayClinicObjects = response

      console.log(arrayClinicObjects);
      var clinicCount = arrayClinicObjects.length;
      console.log(clinicCount);

      for (var i=1; i < clinicCount; i++){

        // for (var i=1; i < 2; i++){

          if ((arrayClinicObjects[i].lat)&&(arrayClinicObjects[i].lng)){
            console.log("INSIDE IF");

            arrayClinicObjects[i].lat = parseFloat(arrayClinicObjects[i].lat)

            arrayClinicObjects[i].lng = parseFloat(arrayClinicObjects[i].lng)
          // console.log(arrayClinicObjects[i]);
          // createMarker(arrayClinicObjects[i]);
        }
        else {
          console.log("INSIDE ELSE");
          latLngData(arrayClinicObjects[i]);
        }

      }
    });
  }

  function clinicNameAndAddress(id){
    $.ajax({
      type: 'GET',

      url: "/clinics/"+id+"/data"
    })
    .done(function(response){
      // console.log(response);
      var clinicObj = jQuery.parseJSON(response);
      // console.log(clinicObj);

    })
    .fail(function(xhr,unknown,error){
      alert(error);
    });
  }

  // function latLngData(clinicObj){
  //   $.ajax({
  //     type: 'GET',
  //     url: "/geolocate/"+clinicObj.id+"/"+clinicObj.full_address,


      url: "/geolocate/"+clinicObj.name+"/"+clinicObj.full_address
    })
    .done(function(response){
      console.log("latLngData RESPONSE");
    // console.log(response);
    // clinicObj.lat = response.results[0].geometry.location.lat;
    // clinicObj.lng = response.results[0].geometry.location.lng;
    // saveLatLngData(clinicObj);
  })
    .fail(function(xhr,unknown,error){
      alert(error);
    });
  }


  function saveLatLngData(clinicObj){
    // clinicInfo = {};
    // clinicInfo.id = clinicObj.id;
    // clinicInfo.lat = clinicObj.lat;
    // clinicInfo.lng = clinicObj.lng;
    $.ajax({
      type: 'PUT',

      url: "/saveLatLng/"+clinicObj.id+"/"+clinicObj.lat+"/"+clinicObj.lng
    })
    .done(function(response){
      console.log("saveLatLngData RESPONSE");
      console.log(response);
      // createMarker(clinicObj);
    })
    .fail(function(xhr,unknown,error){
      alert(error);
      console.log(error);
    });

  }


// }
